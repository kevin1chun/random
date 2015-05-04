__kernel void incr (__global float *Y, int n)
{
	/** This is the kernel, of which many copies are run,
	each computing a single increment value,  based on their global_id*/
  int idx = get_global_id(0);
  if(idx < n)
    {
      Y[idx] = Y[idx] + 1.0f;
    }
}
