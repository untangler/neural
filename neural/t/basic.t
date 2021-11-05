use v6;

use Test;

use lib <lib>;

use-ok 'NeuralNet';
use NeuralNet;

constant @trainingSet = (
  [1, 1] => -1,
  [1, -1] => 1,
  [-1, 1] => 1,
  [-1, -1] => 1,
);

my NeuralNet $net .= new;

$net.train(@trainingSet);
$net.test(@trainingSet);
my ($nTests, $nSuccess) = $net.getResults();
is $nTests, 4, 'number of tests';
is $nSuccess, 4, 'number of successes';

$net.showWeights;