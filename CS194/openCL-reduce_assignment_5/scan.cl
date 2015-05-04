/*
    This kernel simple updates each element in a section
    with the value from the meta scan array generated by 
    a prior all to scan. 
*/
__kernel void update(__global int *in,
		     __global int *block,
		     int n)
{
  size_t idx = get_global_id(0);
  size_t tid = get_local_id(0);
  size_t dim = get_local_size(0);
  size_t gid = get_group_id(0);

  if(idx < n && gid > 0)
    {
      in[idx] = in[idx] + block[gid-1];
    }
}

/*
    This kernel implements the naive 2-buffer solution to scanning sections 
    of an array. It then outputs the max value of that section to the meta array bout, 
    which is used by update. 
*/
__kernel void scan(__global int *in, __global int *out, __global int *bout, __local int *buf, int n) {

  size_t tid = get_local_id(0);
  size_t dim = get_local_size(0);
  size_t gid = get_group_id(0);

    int dataOffset = dim * gid;  

    int pout = 0;
    int pin = 1;

    
    buf[pout*dim + tid] = in[dataOffset + tid];

    barrier(CLK_LOCAL_MEM_FENCE);

    for(int offset = 1; offset < dim; offset *= 2) {
        pout = 1 - pout;
        pin = 1 - pout;
        if (tid >= offset) {
            buf[pout*dim+tid] = buf[pin*dim+tid] +  buf[pin*dim+tid - offset];
        } else {
            buf[pout*dim+tid] = buf[pin*dim+tid];
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    out[dataOffset + tid] = buf[pout*dim+tid];


    barrier(CLK_LOCAL_MEM_FENCE);
    if (tid ==0) {
        bout[gid] = buf[pout*dim +  dim - 1];

	} 
}



