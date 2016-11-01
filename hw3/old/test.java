import java.util.concurrent.atomic.*;

class BetterSorryState implements State {
    private byte[] value;
    private byte maxval;
    private AtomicReference<byte> ref;

    BetterSorryState(byte[] v) {
	value = v;
	maxval = 127;
	ref = new AtomicReference<byte>();
    }

    BetterSorryState(byte[] v, byte m) {
	value = v;
	maxval = m;
	ref = new AtomicReference<byte>();
    }

    public int size() { return value.length; }

    public byte[] current() { return value; }

    public boolean swap(int i, int j) {
	if (value[i] <= 0 || value[j] >= maxval) {
	    return false;
	}
	ref.weakCompareAndSet(value[i], value[i] - 1);
       	ref.weakCompareAndSet(value[j], value[i] + 1);
	//	value[i]--;
	//	value[j]++;
	return true;
    }
}
