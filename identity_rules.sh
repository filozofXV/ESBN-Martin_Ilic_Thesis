#!/bin/bash


for r in {1..100}
do

	# batch_size = 32
	py ./train_and_eval.py --encoder "rand" --run $r --train_batch_size 32 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
	
	# batch_size = 16
	py ./train_and_eval.py --encoder "rand"  --run $r --train_batch_size 16 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
	
	# batch_size = 8
	py ./train_and_eval.py --encoder "rand"  --run $r --train_batch_size 8 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
	
	# batch_size = 4
	py ./train_and_eval.py --encoder "rand"  --run $r --train_batch_size 4 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
	
	#----------------------------------
	
	# batch_size = 32
	py ./train_and_eval.py --encoder "conv" --run $r --train_batch_size 32 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
	
	# batch_size = 16
	py ./train_and_eval.py --encoder "conv"  --run $r --train_batch_size 16 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
	
	# batch_size = 8
	py ./train_and_eval.py --encoder "conv"  --run $r --train_batch_size 8 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
	
	# batch_size = 4
	py ./train_and_eval.py --encoder "conv"  --run $r --train_batch_size 4 --model_name "ESBN" --norm_type contextnorm --lr 5e-4 --task identity_rules --m_holdout 95 --epochs 50 --train_gen_method full_space --test_gen_method subsample
done