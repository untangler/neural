use v6;

use Test;

use lib <lib>;

use-ok 'Perceptron';
use Perceptron;

constant @trainingSet = (
  [1, 1] => -1,
  [1, -1] => 1,
  [-1, 1] => 1,
  [-1, -1] => 1,
);

my Perceptron $perceptron .= new;
$perceptron.setTestSize(200);

$perceptron.train(@trainingSet);
$perceptron.test(@trainingSet);
my ($nTests, $sessions, $nSuccess) = $perceptron.getResults();
is $nTests, 4, 'number of tests';
#is $nSuccess, 4, 'number of successes';
print 'number of succesful tests ', $nSuccess, "\n";
print 'number of training sessions ', $sessions , "\n";
$perceptron.showweightArrs;