__kernel void vvadd (__global float *Y, __global float *A, __global float *B, 
	 int n)
{
  /* CS194: implement the body of this kernel */
  int idx = get_global_id(0);
  if(idx < n)
    {
      Y[idx] = A[idx] + B[idx];
    }
}
