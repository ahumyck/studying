from hashlib import sha1

base_path = "D:/labs/javacode/bTorrent/src/com/company/bencode/python/"
my_torrent_file = "mro2_2.torrent"
ubuntu_torrent_file = "ubuntu-mate-18.04.5-desktop-amd64.iso.torrent"

if __name__ == "__main__":
    with open(base_path + ubuntu_torrent_file, 'r') as f:
        content = f.read()
        print(bytearray(sha1(bytearray(str.encode(content[content.find("d6:length"): -1], encoding="cp1251"))).digest()))
        print(sha1(bytearray(str.encode(content[content.find("d6:length"): -1], encoding="cp1251"))).hexdigest())
