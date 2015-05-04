

import sys
import fileinput
import csv
import pyopencl as cl
import numpy
from scipy import stats
from collections import Counter
import time




kernelName = './kernel.cl'

if (len(sys.argv) != 5):
  exit("Usuage: [std features] [std labels] [input features] [k]");
  
  
def readCSV(filename):
  f = open(filename,'rb')
  reader = csv.reader(f)
  output = []
  for row in reader:
    features = []
    for col in row:
      features.append(numpy.float32(col))
    output.append(features)
  f.close()
  return output

def convertObervationList(L):
  numObservations = len(L)
  featuresPerObersvation = len(L[0])
  
  output = numpy.empty(numObservations * featuresPerObersvation, dtype=numpy.float32)
  
  for i in range(0, numObservations):
    observation = L[i]
    for j in range(0, len(observation)):
      output[i*featuresPerObersvation + j] = observation[j]
  return output
  
def readFileString(fname):
  with open(fname, 'r') as content_file:
      content = content_file.read()
  return content

#returns the distance between two obervations, represented as 
def obervationDistance(ob1, ob2):
  sum = numpy.float32(0)
  for i in range(0, len(ob1)):
    sum += numpy.square(ob1[i] - ob2[i])
  return numpy.sqrt(sum)
  
def mergeBest(index, dist, current):
  for i in range(0, len(current)):
    if (dist < current[i][1]):
      temp = current[i]
      current[i] = (index, dist)
      mergeBest(temp[0], temp[1], current)
      break


def refeature(L):
  numObservations = len(L)
  featuresPerObersvation = len(L[0])
  out = []

  for observation in L:
    fSet = []
    stride = 3
    #horizontal lines
    for row in range(0, 28, 1):
      for col in range(0, 28-stride, stride):
        fSet.append(horizLine(observation, row, col, stride))

    out.append(fSet)

  return out

def horizLine(observation, row, col, stride):
  sum = 0
  for i in range(0, stride):
    sum += observation [28 * row + col + i]
  return sum
#get each std obervation
stdFeaturesList = (readCSV(sys.argv[1]))
stdFeatures = convertObervationList(stdFeaturesList)

#labels for std obervations
stdLabelsList = readCSV(sys.argv[2])
stdLabels = convertObervationList(stdLabelsList)

#input obervations to classify
inputFeaturesList = (readCSV(sys.argv[3]))
inputFeatures = convertObervationList(inputFeaturesList)

#get the number of features from the first observation in stdFeatures
numStdObservations = numpy.int32(len(stdFeaturesList))
numInputObservations = numpy.int32(len(inputFeaturesList))
featuresPerObersvation = numpy.int32(len(stdFeaturesList[0]))

k =  numpy.int32((sys.argv[4]))



ctx = cl.create_some_context()
commandQueue = cl.CommandQueue(ctx)

#print "Building kernel " , kernelName
program = cl.Program(ctx, readFileString(kernelName)).build()

cl.mem_flags

#client array


#GPU buffers
gStdFeatures = cl.Buffer(ctx, cl.mem_flags.READ_ONLY | cl.mem_flags.COPY_HOST_PTR, hostbuf = stdFeatures)

gInputFeatures = cl.Buffer(ctx, cl.mem_flags.READ_ONLY | cl.mem_flags.COPY_HOST_PTR, hostbuf = inputFeatures)

dest_indices = cl.Buffer(ctx, cl.mem_flags.WRITE_ONLY, inputFeatures.nbytes * k)

dest_buf = cl.Buffer(ctx, cl.mem_flags.WRITE_ONLY, inputFeatures.nbytes * k )


#Run Kernel
program.test(commandQueue, inputFeatures.shape, None, gStdFeatures, gInputFeatures, dest_buf, dest_indices, numStdObservations, numInputObservations, featuresPerObersvation, k)

#client out array
out1 = numpy.empty(numInputObservations * k , dtype=numpy.float32)

out2 = numpy.empty(numInputObservations * k , dtype=numpy.int32)

#copy gArray1 to out1
cl.enqueue_read_buffer(commandQueue, dest_buf, out1).wait()
cl.enqueue_read_buffer(commandQueue, dest_indices, out2).wait()

def mode(labels): #breaks ties by returning the smallest
  temp = stats.mode(labels)
  mode = temp[0][0]
  return mode

for i in range(0, len(inputFeaturesList)): #
  kClosest = out2[i*k: i*k+k]
  labels = []
  for neighbor in kClosest:
    labels.append(stdLabelsList[neighbor])



  print int(mode(labels))








