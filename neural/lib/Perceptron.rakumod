class Perceptron {
  has @.weightArr;
  has $.nTests = 0;
  has $.nSuccess = 0;
  has $.eta = 0.1;
  has $.nrOfTrainingSessions = 10;

  method setTestSize($nr) {
    $!nrOfTrainingSessions = $nr;
  }

  method !pickSet(@set) {
    # say 'random number ', 4.rand.Int;
    my $randomIndex = 4.rand.Int;
    return @set[$randomIndex];
  } 

  method train(@trainingSet) {
    my $nrOfInputs = @trainingSet[0].key.elems;
    @!weightArr = (0) xx ($nrOfInputs + 1);

    #for @trainingSet -> $rule {
    for 0...$!nrOfTrainingSessions -> $session {
      my $trainingExample = self!pickSet(@trainingSet);
      # say 'random trainingExample ', $trainingExample;
      my ($input, $output) = $trainingExample.kv; 
      my $result = self!compute($input);
      if $result != $output {
        my @x = @$input;
        @x.unshift(1);
        for @x.kv -> $ix, $x {
          @!weightArr[$ix] -= $!eta * $x * $result.sign;
        }
      }   
    } 
  }
  method apply(@inputs) { 
    gather for @inputs -> $example {
      my ($input, $output) = $example.kv; 
      my $result = self!compute($input);
      take $result;
    }
  }

  method test(@rules) { 
    for @rules -> $rule {
      $!nTests++;
      my ($input, $output) = $rule.kv; 
      my $result = self!compute($input);
     # say 'expectation: ', $rule, ' vs reality: ', $result;
      $!nSuccess++ if $result == $output; 
    }
  }
  method getResults { 
    return ($!nTests, $.nrOfTrainingSessions, $!nSuccess);
  }
  method showweightArrs {
    say "The weightArrs are: @!weightArr[]";
  }

  method !compute(@input) {
    my @in = @input;
    @in.unshift(1);
    my $sum = 0;
    for @in.kv -> $i, $value {
      $sum += @!weightArr[$i] * $value;
    }
    # return $sum.sign || (-1, 1).pick;
    return $sum.sign || 1;
  }
}