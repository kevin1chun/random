
__kernel void matmul(__global float *Y, __global float *A, __global float *B, 
	 int n)
{
  /* CS194: Compute the value of a single output cell. */
  
  
    int row = get_global_id(0);
    int col = get_global_id(1);

    if (row < n && col < n) {
        Y[row * n + col] = 0;
        for (int i = 0; i < n; i ++) {
            Y[row * n + col] +=  A[row * n + i] * B[i * n + col];
        }

    }

}
