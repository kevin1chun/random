__kernel void reduce(__global int *in, __global int *out, 
		      int n)
{
	size_t tid = get_local_id(0);
	size_t gid = get_group_id(0);

	__local int working[128];

	/* Load a single element */
	working[tid] = in[get_local_size(0) * gid + tid];
	barrier(CLK_LOCAL_MEM_FENCE);

	/* Step backwards performing reductions. */
	for (int i = get_local_size(0) / 2; i > 0 ; i = i >> 1 ) {
		if (tid < i) {
			working[tid] += working[tid + i];
		}
		barrier(CLK_LOCAL_MEM_FENCE);
	}



	/* Write out and back to in, in case we are actually outputting a partial sum. */
	if (tid == 0 ) {
		if ( gid == 0) {
			out[0] =  working[0];
		}

		in[gid] = working[0];
	}
}
