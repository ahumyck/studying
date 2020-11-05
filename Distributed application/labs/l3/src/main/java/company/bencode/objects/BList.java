package company.bencode.objects;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class BList extends BElement {
    private final List<BElement> elements = new ArrayList<>();

    public BList() {
    }

    public boolean add(BElement element) {
        return elements.add(element);
    }

    public BElement get(int index) {
        return elements.get(index);
    }

    @Override
    public List<BElement> getValue() {
        return elements;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BList otherList = (BList) o;
        return Objects.equals(elements, otherList.elements);
    }

    @Override
    public int hashCode() {
        return Objects.hash(elements);
    }

    @Override
    public String toString() {
        return elements.toString();
    }

    @Override
    public int compareTo(Object o) {
        boolean equals = equals(o);
        if (equals)
            return 0;
        else return -1;
    }
}
