import java.util.concurrent.atomic.*;

class BetterSorryState implements State {
    private AtomicInteger[] value;
    private byte maxval;

    BetterSorryState(byte[] v) {
	value = new AtomicInteger[v.length];
	for (int i = 0; i < v.length; i++) {
	    value[i] = new AtomicInteger(v[i]);
	}
	maxval = 127;
    }

    BetterSorryState(byte[] v, byte m) {
	value = new AtomicInteger[v.length];
	for (int i = 0; i < v.length; i++) {
	    value[i] = new AtomicInteger(v[i]);
	}
	maxval = m;
    }

    public int size() { return value.length; }

    public byte[] current() {
	byte[] results = new byte[size()];
	for (int i = 0; i < size(); i++) {
	    results[i] = (byte)value[i].intValue();
	}
	return results;
    }

    public boolean swap(int i, int j) {
        if (value[i].intValue() <= 0 || value[j].intValue() >= maxval) {
	    return false;
	}

	value[i].getAndDecrement();
	value[j].getAndIncrement();
	return true;
    }
}
