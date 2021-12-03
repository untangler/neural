


class Neuron {
  has @.weightArr;
  has @.error;
  has @.output;
}


class MultiLevel {
  has $.nTests = 0;
  has $.nSuccess = 0;
  has $.eta = 0.1;
  has $.nrInputs;
  has $.nrLayers = 3;
  has @.layers;
  has @.output;

  #initialise with predefined set, later: method to choose configuration

  method initialiseWeights($nr) {
    my @weights;
    for ^$nr {
      # return random weightsArr between -1 and 1
      @weights.push((2.rand - 1).round(0.1));
    }
    return @weights;
  }

  method buildLayers() {
    my $nrNeuronsPerLayer = 2; 
    my $nrNeuronsOutputLayer = 1; 
    my $startInputs = 2;
    my $nrInputsPerNeuron = $startInputs;
    for ^$!nrLayers -> $layerCnt {
      if $!nrLayers-1 === $layerCnt {
        $nrNeuronsPerLayer = $nrNeuronsOutputLayer;
      }
      my @layer;
      for ^$nrNeuronsPerLayer -> $i {
        my Neuron $neuron .= new;
        $neuron.weightArr = self.initialiseWeights($nrInputsPerNeuron + 1);
        @layer.push($neuron);
      }
      $nrInputsPerNeuron = $nrNeuronsPerLayer;
      @!layers.push(@layer);
    }
    say 'building layers';
    say @!layers;
  }

  method !pickSet(@set) {
    # say 'random number ', 4.rand.Int;
    my $randomIndex = 4.rand.Int;
    return @set[$randomIndex];
  } 

  method train(@truths) {
    my $trainingRule = self!pickSet(@truths);
    my ($inputs, $output) = $trainingRule.kv; 
    say 'inputs ', $inputs;
    self!forwardPass($inputs);
    self!backwardPass($output);
  }

  method !forwardPass(@networkInputs) {
    my @layer_in = @networkInputs;

    for @!layers.kv -> $layerIx, @layer {
      my @layer_out;
      @layer_in.unshift(1);
      
      say  'layer ix: ', $layerIx;

      for @layer.kv -> $neuronIx, $neuron {
        my $z = 0;
        my $n_out;

        say 'inputs layer in: ', @layer_in;
        say 'weights: ', $neuron.weightArr;

        for @layer_in.kv -> $i, $value {
          $z += $neuron.weightArr[$i] * $value;
        }

        if $layerIx !== @!layers.end {
          $n_out = tanh($z);
          @!output = $n_out;
        } else {
          $n_out = S($z);
        }
        $neuron.output = $n_out;
        @layer_out.push($n_out);


        say 'neuron output';
        say $neuron.output;
      }
      @layer_in = @layer_out;
    } 


  }

  method !backwardPass($y_truth) {
    my $MSE = ($y_truth - @!output[0])**2/2;
    my $MSE_der = -($y_truth - @!output[0]);

    my @reverseNetwork  = @!layers.reverse;
    my $errLast = $MSE_der;
    my $der = &SDer;
    
    for @reverseNetwork.kv -> $layerIx, @layer {
      my $layerErr;

      for @layer.kv -> $neuronIx, $neuron {
        $layerErr += $errLast * $der($neuron.output) * $neuron.weightArr;

      }
      $errLast = $layerErr;
      $der = &tanhDer;
    
    }
  }



}





sub tanh ($x) {
  (e**(2 * $x) - 1) / (e**(2 * $x) + 1);
}
sub tanhDer($x) {
  1 - tanh($x) ** 2;
}

sub S($x) {
  (e**($x)) / (e**($x) + 1);
}

sub SDer($x) {
  S($x) * (1 - S($x));
}

