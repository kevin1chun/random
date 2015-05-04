

__kernel void test(__global float* stdObservations, __global float* inputObervations, __global float* dest, __global int* destIndices, int numStd, int numInput, int numFeatures, int k)
{

    size_t idx = get_global_id(0);
    size_t tid = get_local_id(0);
    size_t dim = get_local_size(0);
    size_t gid = get_group_id(0);
  
    for (int i = 0; i < k; i++) {
      dest[idx * k + i] = HUGE_VALF;
    }
    
    if (idx < numInput) {

      for (int i = 0; i < numStd; i ++) {
        float featureSum = 0;
        for (int j = 0; j < numFeatures; j++) {
          float temp = stdObservations[i * numFeatures +  j] - inputObervations[idx * numFeatures + j];
          temp = temp * temp; 
          featureSum += temp;	
        }
        featureSum = sqrt(featureSum);
        int saveI = i;

        for (int i = 0; i < k; i++) {
          if (featureSum <= dest[idx * k + i]) {
            float temp = dest[idx * k + i];
            
            int tempI = destIndices[idx * k + i];
            destIndices[idx * k + i] = saveI;
            saveI = tempI;
            
            dest[idx * k + i] = featureSum;
            featureSum = temp;
          }
        }

      }
    
    } 
 
    
}


      
      
      
