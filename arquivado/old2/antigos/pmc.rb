#!/usr/bin/ruby
#Coding: utf-8

class Conexao
	def initialize(c_origem, n_origem, c_destino, n_destino)
		@c_origem, @n_origem, @c_destino, @n_destino = 	c_origem, n_origem, c_destino, n_destino
		@peso = rand(0.1..0.9)
	end
end


class Neuronio
end


class Camada
	attr_accessor :neuronios
	attr_accessor :tipo_camada
	def initialize(tipo_camada, qtd_neuronios)
		
		## Inicializa o vetor de neurînios, adicionando à camada.
		@tipo_camada = tipo_camada
		@neuronios = [0] * qtd_neuronios
		@neuronios.each_index {|i| @neuronios[i] = Neuronio::new()}
	end
end


class Perceptron_MC
	def initialize(dimensao_rede)
		@vetor_conexoes = []

		## Cria um array que vai conter todas as camadas
		# e define seus tipos. A camada adiciona os 
		# neurônios em seu construtor.
		@camadas = [0] * dimensao_rede.length
		@camadas.each_index do |i|
			if i == 0
				@camadas[i] = Camada::new(:entrada, dimensao_rede[i])
			elsif i == (dimensao_rede.length - 1)
				@camadas[i] = Camada::new(:saida, dimensao_rede[i])
			else
				@camadas[i] = Camada::new(:oculta, dimensao_rede[i])
			end
		end
		
		## Este loop percorre todas as camadas criando as conexões.
		@camadas.each_index do |i|
			next if @camadas[i].tipo_camada == :saida
			@camadas[i].neuronios.each_index do |n_origem|
				@camadas[i + 1].neuronios.each_index do |n_destino|
					@vetor_conexoes.push(Conexao.new(i, n_origem, i + 1, n_destino)) 
				end
			end
		end	
		puts @vetor_conexoes[2]

	end
end



percy = Perceptron_MC::new([2, 3, 1])
#percy.treinar([1, 1, 0], [0, 0, 0], [0, 1, 1], [1, 0, 1])
#percy.executar([0, 0])
#percy.executar([1, 1])
#percy.executar([1, 0])
#percy.executar([1, 1])

