clear all;
KbName('UnifyKeyNames');
addpath('classes/');
addpath('lib/');

function main()
  patient_number = get_patient_num();
  exp1 = experiment1(patient_number);
  do_experiment(exp1);
end


function patient_num = get_patient_num()  
  % ask for patient number
  num_input = input('patient number:');
  % check for integer
  while mod(num_input,1)
    num_input = input('please enter a valid integer value:');
  end
  patient_num = num_input;
end


main();
