#!/usr/bin/env ruby
#Coding: UTF-8
# ***********************************************************************
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: 
# Version: 0.1
# ***********************************************************************

## Valores que servem como parâmetro de controle e serão
## posteriormente ajustados via formulário.
$taxa_de_aprendizado = 0.8
$fator_momentum = 0.2
$bias = 1
$erro_toleravel = 0.01
$limite_de_epocas = 100
$casas_de_precisao = 2
$debug = true

#------------------------------------------------------------------------

class Rede
	attr_accessor :camadas
	def initialize(formato)
		@camadas = []
		formato.each_with_index do |n, c|
			@camadas << Camada::new(self, c, n)
		end
	end
	
	def treina(dados_de_treino)

	end
	
	def executa(dados_de_execucao)
		@dados_de_execucao = dados_de_execucao
		@camadas.each do |c|
			@dados_de_execucao = c.processa(@dados_de_execucao)
		end
	end
end


#------------------------------------------------------------------------


class Camada
	attr_accessor :id
	attr_accessor :rede
	attr_accessor :neuronios
	def initialize(rede, id, qt_neuronios)
		@id = id
		@rede = rede
		@neuronios = []
		qt_neuronios.times do |n|
			@neuronios << Neuronio::new(self, n)
		end
	end
	
	def processa(dados_de_execucao)
		@dados_executados = []
		@neuronios.each do |n|
			@dados_executados << n.processa(dados_de_execucao)
			return dados_executados
		end
	end
end


#------------------------------------------------------------------------


class Neuronio
	def initialize(camada_mae, id)
		@id = id
		@camada_mae = camada_mae
		@rede = @camada_mae.rede
		@entradas = []
		@pesos = []
		@saida = 0
	end
		
	def soma
		@entradas = []
		return 1
	end
	
	def ativa
	end
	
	def processa(dados_de_execucao)
		@dados_de_execucao = dados_de_execucao
		if @camada_mae.id == 0
			@saida = @dados_de_execucao[id] 
		else
			@entradas = @dados_de_execucao
			@saida = @dados_de_execucao[id] 
		
	end
	return @saida
end


#------------------------------------------------------------------------



rede = Rede.new([2, 3, 2])

AND = [
[[0, 0], [0]],
[[0, 1], [0]],
[[1, 0], [0]],
[[1, 1], [1]]]

OR = [
[[0, 0], [0]],
[[0, 1], [1]],
[[1, 0], [1]],
[[1, 1], [1]]]

NOR = [
[[0, 0], [1]],
[[0, 1], [0]],
[[1, 0], [0]],
[[1, 1], [0]]]

XOR = [
[[0, 0], [0]],
[[0, 1], [1]],
[[1, 0], [1]],
[[1, 1], [0]]]

puts "\nTreinando a rede para AND"
rede.treina(AND)

puts "\nTreinando a rede para OR"
rede.treina(OR)

puts "\nTreinando a rede para NOR"
rede.treina(NOR)

puts "\nTreinando a rede para XOR"
rede.treina(XOR)








