#=
T = [[0.272545164 6.5637631e-37 7.93970182e-6 8.61092244e-5 0.165656847 0.287081146 0.000218659173 4.06806091e-13 0.274399041 5.09466694e-6]       
 [0.0835696383 7.05396766e-6 0.206100213 1.52600546e-11 1.53908757e-8 6.5269808e-11 0.673013596 0.0193819808 0.0179275025 3.2272789e-18]       
 [0.886728867 8.63212428e-7 3.94046562e-11 0.110467781 1.11735715e-6 2.12946427e-18 5.16880247e-8 0.000236340361 0.00111600188 0.00144897701]  
 [8.16557898e-11 0.0168992485 6.27227283e-14 0.010767298 0.426756301 1.78050405e-9 6.41316248e-5 0.321159984 0.0369047216 0.187448314]       
 [0.130652141 4.70465408e-6 0.000473601393 0.0378509164 9.06618543e-10 0.000778622816 0.00029383779 0.829914494 8.69688804e-26 3.16817317e-5]  
 [0.223054659 0.288152163 7.35806925e-19 0.0185562602 1.73073908e-8 0.400936069 1.17437994e-12 0.0443974641 0.0249033671 7.2202285e-18]        
 [4.78064507e-16 0.320444079 0.00385904296 1.26156421e-9 0.00688364264 0.00447186979 0.156660567 0.169796226 0.333780163 0.00410440864]        
 [4.84470444e-13 2.5025163e-14 2.78748146e-7 0.00245132866 3.03033036e-12 0.00284425237 8.49830551e-7 6.60111797e-8 0.994702713 5.11768273e-7] 
 [0.16839645 1.80280379e-7 5.68958062e-11 0.134838199 0.00020810431 0.0861188042 0.0517409105 0.361825373 3.31239961e-11 0.196871978]          
 [0.0474764005 1.16126593e-6 5.96036112e-8 0.00128470373 1.30134792e-6 0.0374283978 0.310068428 2.27075277e-19 0.00647484474 0.597264703]]; 
=#

# obs = [ 4.496711176792789,8.409519656104697,9.460916757433266,4.167265725138652,9.257095724525986,4.459335365585336,10.444998457742154,7.125563417165201,9.452392690674609,8.219434105516523,9.499677510003142,4.045260615800268,5.092336115035037,8.440151120540706,9.481322486443823,4.1506674754345125,10.42790704799399,7.054651769417384,9.412840879676432,7.456448909790861,7.14452018692043,2.279022868843048,7.318144706180005,2.2484762958178415,3.4629337466679937,1.1915917312461404,5.400294500416449,8.184702480435064,9.120004299641932,8.473421399391462,9.025259713637169,1.2901328101659788,6.308110160953595,6.273001919099665,2.3479610214974356,7.323522393971871,7.2425244029951115,7.4363280421562905,7.092997752774523,9.1182000862844,8.183858734827265,9.351783803123448,8.145654018480665,9.257692515655915,4.422053340550628,5.4936218073185135,8.153373938761792,9.073965616826253,7.399028760579227,9.147205306011715,8.29858611104011 ];


K = 5
N = 201
initial = fill(1.0 / K, K)
means = (collect(1.0:K)*2-K)*2

# Define transition matrix
T = zeros(K,K); for i=1:K; T[i,:] = rand(Dirichlet(ones(K)./K)); end
T = T + K*eye(K)/K; for i=1:K; T[i,:] = T[i,:] ./ sum(T[i,:]); end # Add self-trans prob.


@model hmmdata begin 
    states = tzeros(Int,N)
    # T = TArray{Array{Float64,}}
    y = zeros(N)

    states[1] ~ Categorical(initial)
    for i = 2:N
        states[i] ~ Categorical(vec(T[states[i-1],:]))
        y[i] ~ Normal(means[states[i]], 0.4)
    end
    return y
end

srand(1234)
chain = sample(hmmdata, PG(10,2));
obs = chain.value[1].value[:y]
srand()

