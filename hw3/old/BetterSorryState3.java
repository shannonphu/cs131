import java.util.concurrent.atomic.*;

class BetterSorryState implements State {
    private byte[] value;
    private byte maxval;

    BetterSorryState(byte[] v) {
	value = v;
	maxval = 127;
    }

    BetterSorryState(byte[] v, byte m) {
	value = v;
	maxval = m;
    }

    public int size() { return value.length; }

    public byte[] current() {
	return value;
    }

    public boolean swap(int i, int j) {
	AtomicInteger a_i = new AtomicInteger(value[i]);
	AtomicInteger a_j = new AtomicInteger(value[j]);
	
        if (a_i.intValue() <= 0 || a_j.intValue() >= maxval) {
	    return false;
	}
	
	value[i] = (byte)a_i.getAndDecrement();
	value[j] = (byte)a_j.getAndIncrement();
	return true;
    }
}
