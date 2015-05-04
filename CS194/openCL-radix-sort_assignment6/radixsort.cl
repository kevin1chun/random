__kernel void reassemble(__global int *zeroes, __global int *ones, 
                __global int *in, __global int *out,int pos, int n)
{
  size_t idx = get_global_id(0);
  size_t tid = get_local_id(0);
  size_t dim = get_local_size(0);
  size_t gid = get_group_id(0);

  int oneOffset = zeroes[n - 1] - 1;

  if (idx < n) {

    if ((in[idx] >> pos) & 0x1) {
      out[oneOffset + ones[idx]] = in[idx];

    } else {
      out[zeroes[idx] - 1] = in[idx];

    }
  }

}

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

__kernel void scan(__global int *in, __global int *out, __global int *bout,
		   /* dynamically sized local (private) memory */
		   __local int *buf, 
		   int v,
		   int k,
		   int n)
{
  size_t idx = get_global_id(0);
  size_t tid = get_local_id(0);
  size_t dim = get_local_size(0);
  size_t gid = get_group_id(0);
  int t, r = 0, w = dim;
  int pout = 0;
  int pin = 1;
  int dataOffset = dim * gid;  

  if(idx<n)
    {
      t = in[dataOffset + tid];
      /* CS194: v==-1 used to signify 
       * a "normal" additive scan
       * used to update the partial scans */
      t = (v==-1) ? t : (v==((t>>k)&0x1)); 
      buf[pout*dim + tid] = t;
    }
  else
    {
      buf[pout*dim + tid] = 0;
    }
  
  barrier(CLK_LOCAL_MEM_FENCE);

  /* CS194: Your scan code from HW 5 
   * goes here */

    //buf[pout*dim + tid] = in[dataOffset + tid];

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



