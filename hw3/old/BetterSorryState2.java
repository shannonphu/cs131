import java.util.concurrent.atomic.AtomicIntegerArray;

class BetterSorryState implements State {
    private AtomicIntegerArray value;
    private byte maxval;

    BetterSorryState(byte[] v) {
	value = new AtomicIntegerArray(v.length);
	for (int i = 0; i < v.length; i++) {
	    value.set(i, v[i]);
	}
	maxval = 127;
    }

    BetterSorryState(byte[] v, byte m) {
	value = new AtomicIntegerArray(v.length);
	for (int i = 0; i < v.length; i++) {
	    value.set(i, v[i]);
	}
	maxval = m;
    }

    public int size() { return value.length(); }

    public byte[] current() {
	byte[] results = new byte[size()];
	for (int i = 0; i < size(); i++) {
	    results[i] = (byte)value.get(i);
	}
	return results;
    }

    public boolean swap(int i, int j) {
	if (value.get(i) <= 0 || value.get(j) >= maxval) {
	    return false;
	}
	
	int t1 = value.get(i) - 1;
	int t2 = value.get(j) + 1;
	value.set(i, t1);
	value.set(j, t2);
	return true;
    }
}
