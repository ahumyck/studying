import bencodepy
import os
from urllib import request
from urllib import parse
import threading
import time
import hashlib
import struct
import socket
import bitstring

MY_PORT = 6968
PROTOCOL_ID = 0x41727101980
TRANSACTION_ID = 123
MAX_NUMB_PEERS = 10
PIECE_SIZE = 16384

#рандомный пир в 20 знаков
def random_peer_id():
    from random import choice
    from string import digits
    return ''.join(choice(digits) for _ in range(20))


#получаем хэш словаря файла
def compute_hash(info):
    return hashlib.sha1(info).digest()

#декодируем пиры из ответа трекера
#список пиров, представленный бинарной строкой, состоящей из частей по 6 байт.
#В каждой части 4 байта отвечают за IP-адрес пира и 2 — за номер порта 
#(так как мы используем компактный формат).
def decode_peers(peers):
    peers = [peers[i:i + 6] for i in range(0, len(peers), 6)]
    return [(socket.inet_ntoa(p[:4]), struct.unpack('!H', (p[4:]))[0]) for p in peers]

#получение битфилда после рукопожатия 
#Сообщение BitField содержит последовательность байтов.
#Если прочесть их в бинарном режиме, то каждый бит 
#будет представлять один фрагмент. 
#Если бит равен 1, то это значит, что у пира есть 
#такой фрагмент, если 0 — такого фрагмента нет. 
#Таким образом, каждый байт представляет до 8 фрагментов.
def get_bitfield_data(raw_data):
    return map(lambda x: int(x), list(bitstring.BitArray(raw_data[1:]).bin))

#выставляем 1, если пир есть
def set_have(raw_data, bitfield):
    piece_numb = struct.unpack('!I', raw_data[1:])[0]
    bitfield[piece_numb] = 1

# это состояние говорит о том, что пир заинтересован в получении фрагментов;
#После обмена рукопожатиями мы отправляем 
#сообщение Interested удалённому пиру, говоря о том, 
#что мы хотим перейти в состояние Unchoked, чтобы начать запрашивать фрагменты.
def send_interested(peer_socket):
    data = struct.pack('!I', 1) + struct.pack('!B', 2)
    peer_socket.sendall(data)


def interested(bitfield, downloaded_pieces):
    for i in range(len(downloaded_pieces)):
        bit = bitfield[i] - downloaded_pieces[i]
        bitfield[i] = bit if bit > 0 else 0
    if sum(bitfield) > 0:
        return True
    else:
        return False

#Not interested (не заинтересован) — это состояние говорит о том, 
#что пир не заинтересован в получении фрагментов.
def send_not_interested(peer_socket):
    data = struct.pack('!I', 1) + struct.pack('!B', 3)
    peer_socket.sendall(data)

#запрашиваем фрагмент
def send_piece_numb(peer_socket, index, length, begin=0):
    data = struct.pack('!BIII', 6, index, begin, length)
    data_s = struct.pack('!I', len(data)) + data
    peer_socket.sendall(data_s)

#формирование запроса для трекера
def connect_tracker(dict_hash, peer_id):
    announce = my_ordered_dict[b'announce'].decode()
    #формирование запроса
    if announce.startswith('http'):
        payload = {'info_hash': dict_hash, 'peer_id': peer_id,
                   'port': MY_PORT, 'evented': 'started',
                   'uploaded': '0', 'downloaded': '0', 'left': str(full_length), 'compact': '1', 'numwant': '100'}

        full_url = "{}?{}".format(announce, parse.urlencode(payload))
        req = request.Request(full_url)
        req.method = "GET"
        http_resp = request.urlopen(req)
        #обрабатываем ответ 
        if http_resp:
            resp = http_resp.read()
            if b'failure reason' not in resp:
                answer_dict = bencodepy.decode(resp)
                return decode_peers(answer_dict[b'peers'])
            else:
                print("failure in connecting to tracker")
        else:
            print("Can't Connect Tracker")

    else:
        print("Can't Connect Tracker")

#для установки соединения с пирами
def check_partial_torrent():
    numb_pieces = len(pieces)
    piece_length = my_ordered_dict[b'info'][b'piece length']
    if os.path.exists(save_directory + "/" + file):
        with open(save_directory + "/" + file, "r+b") as cur_file:
            for i in range(numb_pieces):
                cur_file.seek(i * piece_length)
                piece = cur_file.read(piece_length)
                if compute_hash(piece) == pieces[i]:
                    downloaded_pieces[i] = 1

#отправка запроса пирам
def send_request(bitfield, peer_socket, my_pieces):
    for i in range(len(bitfield)):
        if bitfield[i] == 1:
            try:
                pieces_lock.acquire()
                if downloaded_pieces[i] == 0:
                    downloaded_pieces[i] = 1
                    pieces_lock.release()
                    my_pieces[i] = b''
                    send_piece_numb(peer_socket=peer_socket, index=i, length=PIECE_SIZE)
                    break
                else:
                    pieces_lock.release()
            except:
                break


#сохраняем в файл
def write_block_in_file(block, index, begin):
    new_bytes = len(block)
    begin = my_ordered_dict[b'info'][b'piece length'] * index
    with open(save_directory + "/" + file, "r+b") as cur_file:
        cur_file.seek(begin)
        cur_file.write(block)
    with lock:
        global downloaded_bytes
        downloaded_bytes += new_bytes

#распаковываем пришедший блок
def unpack_piece(raw_data, my_pieces, peer_socket, bitfield):
    try:
        index, begin = struct.unpack('!II', raw_data[:8])
        block = raw_data[8:]
        my_pieces[index] += block
        prev_bytes = my_ordered_dict[b'info'][b'piece length'] * index
        global downloaded_bytes

        lock.acquire()

        if len(my_pieces[index]) == my_ordered_dict[b'info'][b'piece length'] or ((index == len(pieces) - 1 and prev_bytes + len(my_pieces[index]) == full_length)):
            lock.release()
            if compute_hash(my_pieces[index]) == pieces[index]:
                write_block_in_file(my_pieces[index], index, begin)
                if sum(downloaded_pieces) != len(pieces):
                    send_request(bitfield, peer_socket, my_pieces)
                    return False
                else:
                    return True
            else:
                with pieces_lock:
                    downloaded_pieces[index] = 0
                print("hash wasn't correct ")
                return True
        else:
            lock.release()

            if index == len(pieces) - 1 and prev_bytes + len(my_pieces[index]) + PIECE_SIZE > full_length:
                last_piece_size = full_length - prev_bytes - len(my_pieces[index])
                if last_piece_size == 0: return False
                send_piece_numb(peer_socket=peer_socket, index=index, length=last_piece_size,
                                begin=len(my_pieces[index]))
            else:
                send_piece_numb(peer_socket=peer_socket, index=index, length=PIECE_SIZE,
                                begin=len(my_pieces[index]))
            return False
    except:
        lock.release()
        return True


def process_data(raw_data, bitfield, my_pieces, peer_socket):
    try:
        if 5 == struct.unpack('!B', raw_data[:1])[0]:
            bitfield += get_bitfield_data(raw_data)
            with pieces_lock:
                if interested(bitfield, downloaded_pieces):
                    send_interested(peer_socket)
                else:
                    send_not_interested(peer_socket)
                    return True

        if 4 == struct.unpack('!B', raw_data[:1])[0]:
            set_have(raw_data, bitfield)
            return False

        if 1 == struct.unpack('!B', raw_data[:1])[0]:
            if bitfield:
                send_request(bitfield, peer_socket, my_pieces)
            return False

        if 0 == struct.unpack('!B', raw_data[:1])[0]:
            return True

        if 7 == struct.unpack('!B', raw_data[:1])[0]:
            return unpack_piece(raw_data[1:], my_pieces, peer_socket, bitfield)

        return False
    except:
        return True


def restore_info(my_pieces):
    for index, piece in my_pieces.items():
        if len(piece) < my_ordered_dict[b'info'][b'piece length']:
            try:
                pieces_lock.acquire()
                downloaded_pieces[index] = 0
            except:
                pass
            finally:
                pieces_lock.release()


def download_data(peer_socket, peer):
    peer_socket.settimeout(5)
    bitfield = []
    my_pieces = {}

    try:
        while True:
            data = b''
            while len(data) < 4:
                new_data = peer_socket.recv(4 - len(data))
                if new_data == b'':
                    continue
                data += new_data
                peer_socket.settimeout(5)

            msg_length = struct.unpack('!I', data)[0]

            if msg_length == 0:
                continue
            data = b''
            while msg_length > 0:
                raw_data = peer_socket.recv(msg_length)
                if raw_data == b'':
                    break
                peer_socket.settimeout(5)
                data += raw_data
                msg_length -= len(raw_data)

            peer_socket.settimeout(None)
            choked = process_data(data, bitfield, my_pieces, peer_socket)
            if choked:
                if sum(downloaded_pieces) != len(pieces):
                    restore_info(my_pieces)

                break

    except (socket.timeout, OSError):
        restore_info(my_pieces)


def get_handshake(info_hash, id):
    protocol_name = b'BitTorrent protocol'
    data = struct.pack('!B', len(protocol_name))
    data += protocol_name
    data += struct.pack('!Q', 0)
    data += info_hash
    data += bytes(id, 'ascii')
    return data


def connect_to_peer(peer):
    handshake = get_handshake(dict_hash, my_peer_id)
    peer_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    global connected_peers
    try:
        peer_socket.connect(peer)
        peer_socket.sendall(handshake)
        peer_socket.settimeout(5)
        interested = peer_socket.recv(len(handshake))
        if interested:
            if dict_hash == struct.unpack('!20s', interested[28:48])[0]:
                with lock:
                    connected_peers.append(peer)

                peer_socket.settimeout(None)
                download_data(peer_socket, peer)
            else:
                peer_socket.close()
    except (socket.timeout, OSError):
        print("timeout while connecting to peer")
    peer_socket.close()
    with lock:
        if peer in connected_peers:
            connected_peers.remove(peer)


def download():
    if sum(downloaded_pieces) != len(pieces):
        print("---- Connecting tracker ---- ")
        peers_ips = connect_tracker(dict_hash, my_peer_id)
        if len(peers_ips) > 0:
            print("---- Connecting peers ----")
            global thread_i
            while True:
                try:
                    lock.acquire()
                    if thread_i < len(peers_ips) and len(connected_peers) < MAX_NUMB_PEERS and downloaded_bytes != full_length:
                        lock.release()
                        peer = peers_ips[thread_i]
                        threading.Thread(target=connect_to_peer, args=(peer,), daemon=True).start()
                        thread_i += 1
                        time.sleep(5)
                    else:
                        lock.release()
                        if downloaded_bytes == full_length or thread_i == len(peers_ips):
                            #connected_peers.clear()
                            break
                        time.sleep(5)
                except:
                    print("Downloading stopped")
                    break


def log_info():
    import datetime
    while True:
        time.sleep(logging_time)
        percent = (downloaded_bytes / full_length) * 100
        if percent > 100:
            percent = 100
        print("FILE: {0:} ({1:.2f} %)".format(file, percent))
        print("    D: {}KB".format(int(downloaded_bytes / 1000)))
        print("    P: {}".format(len(connected_peers)))


logging_time = 5
path_torrent_file = 'debian.torrent'
save_directory = os.getcwd()
print(save_directory)

my_ordered_dict = bencodepy.decode_from_file(path_torrent_file)
dict_hash = compute_hash(bencodepy.encode(my_ordered_dict[b'info']))
my_peer_id = random_peer_id()

hashes = my_ordered_dict[b'info'][b'pieces']

root_directory = ""
files = []
file = ()

file = str(my_ordered_dict[b'info'][b'name'], 'utf-8')
if not os.path.exists(save_directory + "/" + file):
    open(save_directory + "/" + file, "w+b")

pieces = [hashes[i:i + 20] for i in range(0, len(hashes), 20)]
downloaded_pieces = [0] * len(pieces)
check_partial_torrent()
print("{} number of pieces out of {} has been already downloaded".format(sum(downloaded_pieces), len(downloaded_pieces)))
full_length = 0
if b'length' in my_ordered_dict[b'info'].keys():
    full_length = my_ordered_dict[b'info'][b'length']
else:
    for file in my_ordered_dict[b'info'][b'files']:
        full_length += file[b'length']

downloaded_bytes = sum(downloaded_pieces) * my_ordered_dict[b'info'][b'piece length']
connected_peers = []
lock = threading.Lock()
pieces_lock = threading.Lock()
thread_i = 0
threading.Thread(target=log_info, args=(), daemon=False).start()
threading.Thread(target=download, daemon=False).start()
