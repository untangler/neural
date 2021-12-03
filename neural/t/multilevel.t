use v6;

use Test;

use lib <lib>;

use-ok 'MultiLevel';
use MultiLevel;

#constant @trainingSet = (
  #[1, 1] => -1,
  #[1, -1] => 1,
  #[-1, 1] => 1,
  #[-1, -1] => 1,
#);

constant @trainingSet = (
  [1, 1] => 0,
  [1, -1] => 1,
  [-1, 1] => 1,
  [-1, -1] => 0,
);

my MultiLevel $network .= new;
$network.buildLayers();
$network.train(@trainingSet);
# $perceptron.setTestSize(100);

# $perceptron.train(@trainingSet);
# $perceptron.test(@trainingSet);
# my ($nTests, $sessions, $nSuccess) = $perceptron.getResults();
# is $nTests, 4, 'number of tests';
# is $nSuccess, 4, 'number of successes';
# #print 'number of succesful tests ', $nSuccess, "\n";
# #print 'number of training sessions ', $sessions , "\n";
# $perceptron.showweightArrs;

# print $perceptron.apply(@trainingSet);
