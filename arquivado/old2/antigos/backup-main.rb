#!/usr/bin/env ruby
#Coding: UTF-8
# ***********************************************************************
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: 
# Version: 0.1
# ***********************************************************************
#require 'sinatra'

## Valores que servem como parâmetro de controle e serão
## posteriormente ajustados via formulário.
$taxa_aprendizado = 0.9
$mommentum = 0.3
$bias = 1
$tolerancia = 0.01
$limite_epocas = 100
$pilha = []
$casas_decimais = 4 ##define a precisao da rede


class Rede
	def initialize(dimensao)
		@dimensao = dimensao
		@camadas = []
		@dimensao.each_with_index do |qt_neuronios, id|
			@qt_entradas = qt_neuronios if id == 0
			@camadas << Camada::new(id, qt_neuronios, @qt_entradas)
			@qt_entradas = qt_neuronios
		end
	end

	def treina(padrao)
	@erro_da_rede = 0
	@erro_anterior_da_rede = 1000
	@erro_local = []
	@erro_quadratico = []
	@epocas = 0
	
		## Este é o loop principal que só acaba com a rede treinada ou épocas limítrofes atingidas.
		begin
			puts "\n\n***********| Início da Época #{@epocas} |***********"
			## Este é o loop que executa uma vez a cada época e passa todos os dados pela rede.
			padrao.each do |entradas, esperados|
				@entradas = entradas
				@esperados = esperados
				$pilha = @entradas.dup
				@camadas.each {|c| $pilha = c.propaga }
				@saidas = $pilha.dup
				@erro_local = @esperados.zip(@saidas).map {|esp, sai| (esp.to_f - sai.to_f) }
				$pilha = @erro_local
				@camadas.reverse_each {|c| $pilha = c.retropropaga }
				@erro_quadratico << ((1.0 / 2 ) * ((@erro_local.inject {|e1, e2| e1 + e2}) ** 2))
				puts "@entradas #{@entradas}, @saidas #{@saidas}, @esperados #{@esperados}, @erro_local #{@erro_local}"
			end
			@erro_anterior_da_rede = @erro_da_rede if @epocas > 0 
			@erro_da_rede = ((1.0 / @erro_quadratico.length) * @erro_quadratico.inject {|n1, n2| n1 + n2})
			puts "epoca: #{@epocas}, erro da rede: #{@erro_da_rede}, erro quadratico: #{@erro_quadratico}"
			@erro_quadratico = []
			@epocas += 1 
			if (@erro_da_rede <= $tolerancia)
				puts "Rede convergida!"
				break
			end
		end while (@epocas <= $limite_epocas) 
	end
end



class Camada
	def initialize(id, qt_neuronios, qt_entradas)
		@id = id
		@qt_entradas = qt_entradas
		@neuronios = []
		qt_neuronios.times do |qt|
			@neuronios << Neuronio::new(@id, @qt_entradas)
		end
	end
	
	def propaga
		@entradas = $pilha
		@saidas = []
		@neuronios.each do |n|
			@saidas << n.processa(@entradas)
		end
		return @saidas
	end

	def retropropaga
		@valor_retorno = []
		
		## Código para camadas de saída
		@erros = $pilha
		@neuronios.each_with_index do |n, i|
			## calcula o gradiente deste neurônio.
		#	puts "\nAjustando pesos do neuronio #{i} da camada #{@id}"
		#	puts "Antes: #{n.pesos} (bias = #{n.peso_bias})"
			n.gradiente = @erros[i] * n.derivada_ativacao(n.soma) if @erros.class == Array 
			n.gradiente = @erros * n.derivada_ativacao(n.soma) if @erros.class != Array
			n.entradas.each_index do |j|
				n.pesos[j] = n.pesos[j] + $mommentum + $taxa_aprendizado * n.gradiente * n.entradas[j]
				@valor_retorno << n.pesos[j] * n.gradiente
			end
		#	puts "Depois: #{n.pesos} (bias = #{n.peso_bias})\n"
		end
		
	#	puts "Retropropagação concluída na camada #{@id}\n\n"
	#	puts "--------------------------------------------------------------"
		return @valor_retorno.inject {|n1, n2| n1 + n2} 
	end	
end



class Neuronio
	attr_accessor :entradas
	attr_accessor :gradiente
	attr_accessor :soma
	attr_accessor :pesos
	
	def initialize(id_camada, qt_entradas)
		@qt_entradas = qt_entradas
		@id_camada = id_camada
		@entradas = [nil] * @qt_entradas
		@pesos = [nil] * @qt_entradas
		@pesos.each_index {|i| @pesos[i] = rand(-1.0..1.0) }
		@gradiente = 0
	end
	
	def processa(entradas)
		@entradas = entradas
		return transferencia(somatoria)
	end
	
	def somatoria
		@soma = 0.0
		@entradas.each_with_index do |entrada, indice|
			@soma += entrada * @pesos[indice]
		end
		@soma += $bias 
		return @soma
	end
	
	def transferencia(soma)
		@soma = soma
		return Math.tanh(@soma).round($casas_decimais)
	end
	
	def derivada_ativacao(entrada)
		return 1 - Math.tanh(entrada) ** 2
	end
end









treino_xor1 = [ [[0, 0], [0]], [[0, 1], [1]], [[1, 0], [1]], [[1, 1], [0]] ]
treino_xor2 = [ [[0, 0], [0]], [[1, 1], [0]], [[0, 1], [1]], [[1, 0], [1]] ]
xor = [ [0, 0], [1, 1], [0, 1], [1, 0] ]


rede = Rede::new([2, 1])
rede.treina(treino_xor2)











