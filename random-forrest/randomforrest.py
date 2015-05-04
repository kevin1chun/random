

import sys
import fileinput
import csv
import pyopencl as cl
import numpy
from scipy import stats
from collections import Counter
import time

import random
import math



if (len(sys.argv) != 5):
  exit("Usuage: [std features] [std labels] [input features] [T]");

T =  numpy.int32((sys.argv[4]))

  
def readCSV(filename):
  f = open(filename,'rb')
  reader = csv.reader(f)
  output = []
  i = 0
  for row in reader:
    features = []
    for col in row:
      features.append(numpy.float32(col))
    output.append((i, features))
    i += 1
  f.close()
  return output

#obersvation format (index, features)

#Tree representation (feature, threshold, leftChild, rightChild)

def split(feature, threshold, observations):
  left = []
  right = []
  for observation in observations:
    if (observation[1][feature] >= threshold):
      left.append(observation)
    else:
      right.append(observation)
  return left, right

def entropy(S):
  spam = sum(S)
  ham = len(S) - spam

  pSpam = spam / len(S)
  pHam = ham / len(S)
  if (pSpam == 0):
    pSpam = 1
  if (pHam == 0):
    pHam = 1
  return float(- math.log(pSpam, 2) * pSpam - math.log(pHam, 2) * pHam)

#obersvation format (index, features)


def evaluateSplit(feature, stdObervations, stdClasses):

  S = stdObervations
  A = feature
  Etot = entropy(map(lambda x: stdClasses[x[0]][1][0], stdObervations)) #Entropy(S)

  allValues = map(lambda x: x[1][feature], stdObervations) 
  possibleValues = set(allValues) #

  gainTot = Etot # this will be Gain(S, A) after the following loop finishes

  # here we start with gainTot = Entropy(S), then subtract the second term
  # - Sum ( |Sv| / |S| ) * Entropy(sV) for all V
  for val in possibleValues:

    setVal = filter(lambda x: x[1][feature] == val, stdObervations)
    setVal = map(lambda x: stdClasses[x[0]][1][0], setVal)

    gainTot -= (float(len(setVal)) / len(S)) * entropy( setVal ) 
  return gainTot, random.sample(possibleValues, 1)


def bestSplit(stdObervations, stdClasses):
  numberFeatures = 57
  availableFeatures = []
  best = 0
  bestFeature = None
  bestTheshold = 0
  for i in range(0, 9):
    feature = random.randint(0, numberFeatures - 1)
    val, threshold = evaluateSplit(feature, stdObervations, stdClasses)
    if (val >= best):
      best = val
      bestTheshold = threshold
      bestFeature = feature

  allValues = map(lambda x: x[1][bestFeature], stdObervations)
  possibleValues = set(allValues)

  bestE = 1000
  bestTheshold = None
  sizeLeft = 0
  sizeRight = 0
  for val in possibleValues:
    left, right = split(bestFeature, val, stdObervations)
    if (len(left) == 0 or len(right) == 0):
      continue
    eLeft = entropy(map(lambda x: stdClasses[x[0]][1][0], left))
    eRight = entropy(map(lambda x: stdClasses[x[0]][1][0], right))
    totalE = (eLeft * (float(len(left)) / len(stdObervations)))  + (eRight * (float(len(right)) / len(stdObervations)))
    if (totalE < bestE):
      bestE = totalE
      bestTheshold = val
      sizeLeft = len(left)
      sizeRight = len(right)

  return bestFeature, bestTheshold

def generateSubTree(left, stdClasses, i):
  count = 0
  for obs in left:
    index = obs[0]
    obClass = stdClasses[index][1][0]
    if (obClass == 1):
      count += 1

  if (count <= 0 ): #
    lTree = 0
  elif (count >=  len(left) ):
    lTree = 1
  else:
    lTree = generateRandomTree(left, stdClasses, i -1)
  return lTree

def generateRandomTree(stdObervations, stdClasses, i):
  if (i == 0):
    count = 0
    for obs in stdObervations:
      index = obs[0]
      obClass = stdClasses[index][1][0]

      if (obClass == 1):
        count += 1

    if (count < len(stdObervations) / 2):
      return 0
    else:
      return 1


  bestFeature, bestThreshold = bestSplit(stdObervations, stdClasses)
  print "best split is " , bestFeature
  exit()

  left, right = split(bestFeature, bestThreshold, stdObervations)

  lTree = generateSubTree(left, stdClasses, i)
  rTree = generateSubTree(right, stdClasses, i)


  return ( bestFeature, bestThreshold,lTree , rTree)

def numNodes(tree):
  if (tree == 1 or tree == 0):
    return 0
  return 1 + numNodes(tree[2]) + numNodes(tree[3])


def generateTrees(num, stdObervations, stdClasses, lim):
  Trees = []
  for i in range(0, num):
    Trees.append(generateRandomTree(stdObervations, stdClasses, lim))
    sys.stderr.write("Tree Generated\n")
  return Trees

#obersvation format (index, features)

#Tree representation (feature, threshold, leftChild, rightChild)

def classify(tree, observation):
  if (tree == 0 or tree ==1):
    return tree

  feature = tree[0]
  threshold = tree[1]

  if (observation[1][feature] > threshold):
    return classify(tree[2], observation)
  else:
    return classify(tree[3], observation)


random.seed(12345) #ensures consistency between tests

stdFeaturesList = readCSV(sys.argv[1])

stdLabelsList = readCSV(sys.argv[2])

inputFeaturesList = readCSV(sys.argv[3])

#left, right = split(0, .2, stdFeaturesList)
#print len(left), len(right)

#bestF, bestT = bestSplit(stdFeaturesList, stdLabelsList)

#print bestF, bestT

randF = generateTrees(T, stdFeaturesList, stdLabelsList, 16)



for i in range(0, len(inputFeaturesList)):
  spam = 0
  ham = 0
  for tree in randF:
    out = classify(tree, inputFeaturesList[i])
    if (out == 0):
      ham += 1
    else:
      spam += 1
  if (ham >= spam):
    print 0
  else:
    print 1

