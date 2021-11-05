class NeuralNet {
  has @weight;
  has $nTests = 0;
  has $nSuccess = 0;
  has $eta = 1;

  method train(@trainingSet) {
    my $size = @trainingSet[0].key.elems;
    @weight = (0) xx ($size + 1);

    for @trainingSet -> $rule {
      my ($input, $output) = $rule.kv; 
      my $result = self!compute($input);
      if $result != $output {
        my @x = @$input;
        @x.unshift(1);
        if $result < 0 {
          for @x.kv -> $ix, $x {
            @weight[$ix] += $eta * $x;
          }
        } else {
          for @x.kv -> $ix, $x {
            @weight[$ix] -= $eta * $x;
          }
        }
      }   
    } 
  }
  method apply(@inputs) { ??? }
  method test(@rules) { 
    for @rules -> $rule {
      $nTests++;
      my ($input, $output) = $rule.kv; 
      my $result = self!compute($input);
      $nSuccess++ if $result == $output; 
    }
  }
  method getResults { 
    return ($nTests, $nSuccess);
  }
  method showWeights {
    say "The weights are: @weight[]";
  }

  method !compute(@input) {
    my @in = @input;
    @in.unshift(1);
    my $sum = 0;
    for @in.kv -> $i, $value {
      $sum += @weight[$i] * $value;
    }
    # return $sum.sign || (-1, 1).pick;
    return $sum.sign || 1;
  }
}