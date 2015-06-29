#!/usr/bin/env ruby
#Coding: UTF-8
# ***********************************************************************
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: 
# Version: 0.1
# ***********************************************************************

## Valores que servem como parâmetro de controle e serão
## posteriormente ajustados via formulário.
$taxa_de_aprendizado = 0.789
$fator_momentum = 0.123
$bias = 1
$erro_toleravel = 0.01
$limite_de_epocas = 100
$casas_de_precisao = 8
$auxiliar = 0
$debug = false

class Rede 
	
	def initialize(formato_da_rede)
		@camadas = []
		formato_da_rede.each_with_index do |neuronios, id| 
			@conexoes_de_entrada = neuronios if id == 0
			@camadas << Camada::new(id, neuronios, @conexoes_de_entrada)
			@conexoes_de_entrada = neuronios
		end
	end
	
	def propagacao_adiante(valor_inicial)
		$auxiliar = valor_inicial
		@camadas.each { |c| $auxiliar = c.processa($auxiliar) }
		return $auxiliar
	end
	
	def retropropagacao(erro_inicial)
		@erro_propagado = erro_inicial
		@camadas.reverse_each do |c|
			c.parcela_de_erro_da_camada = []
			c.neuronios.each_with_index do |n, i|
				n.gradiente_local = n.derivada_da_ativacao * @erro_propagado[i] if @erro_propagado.length == 1
				n.gradiente_local = n.derivada_da_ativacao * @erro_propagado[i].inject { |n1, n2| n1 + n2 } if @erro_propagado.length > 1
				n.conexoes.each_with_index do |cn, ci|
					cn.peso_da_conexao = cn.peso_da_conexao + ($taxa_de_aprendizado * n.gradiente_local * cn.entrada_da_conexao) + (cn.momentum * $fator_momentum)
					cn.momentum = cn.peso_da_conexao
					cn.parcela_do_erro = cn.peso_da_conexao * n.gradiente_local
					c.parcela_de_erro_da_camada[ci] = [] if c.parcela_de_erro_da_camada[ci] == nil
					c.parcela_de_erro_da_camada[ci] << cn.parcela_do_erro
				end
			end
			@erro_propagado = c.parcela_de_erro_da_camada.dup
		end
	end
	
	def treinamento(padrao_de_treinamento)
		@epocas = 0
		loop do
			puts "\nÉpoca #{@epocas}"
			@erro_quadratico = []
			puts "Pesos das conexões:"
			@camadas.each { |c| print "[ "; c.neuronios.each { |n| n.conexoes.each { |cn| print "#{cn.peso_da_conexao.round(4)} " }}; print "] "}
			puts "\n"
			padrao_de_treinamento.each do |pt|
				@valor_de_treinamento = pt[0]
				@resposta_esperada = pt[1]
				@saida_da_rede = propagacao_adiante(@valor_de_treinamento)
				@erro_local = @resposta_esperada.zip(@saida_da_rede).map { |esperado, obtido| esperado - obtido }
				@erro_quadratico << @erro_local.map { |n1| n1**2 }
				puts "Entradas: #{@valor_de_treinamento}, Esperada: #{@resposta_esperada}, Obtida: #{@saida_da_rede}, Erro: #{@erro_local}"
				retropropagacao(@erro_local)
			end
			@erro_quadratico_medio = 0.5 * @erro_quadratico.inject { |n1, n2| n1 + n2 }
			@epocas += 1
			if @epocas > $limite_de_epocas
				puts "\nLimite de épocas excedido, encerrando o treinamento da rede."
				break
			elsif @erro_quadratico_medio < $erro_toleravel
				puts "\nA rede foi treinada com sucesso."
				break
			end	
		end
	end
	
	def execucao(padrao)
	padrao.each do |p|
				@saida_da_rede = propagacao_adiante(@resposta_esperada)
				@erro_local = @resposta_esperada.zip(@saida_da_rede).map { |esperado, obtido| esperado - obtido }
				puts "Entradas: #{@valor_de_treinamento}, Esperada: #{@resposta_esperada}, Obtida: #{@saida_da_rede}, Erro: #{@erro_local}"
				@soma_erros_desta_epoca << @erro_local.inject { |n1, n2| n1 + n2 }
				retropropagacao(@erro_local)
			end
	end
end



class Camada
	
	attr_accessor :neuronios
	attr_accessor :parcela_de_erro_da_camada
	
	def initialize(id, neuronios, conexoes_de_entrada)
		@id = id
		@entrada_da_camada = Array::new(conexoes_de_entrada, 0)
		@saida_da_camada = Array::new(neuronios, 0)
		@neuronios = []
		parcela_de_erro_da_camada = []
		neuronios.times { @neuronios << Neuronio::new(:hiperbolica, conexoes_de_entrada) }
	end
	
	def processa(valores_para_processar)
		@valores_processados = []
		@neuronios.each { |n| @valores_processados << n.processa(valores_para_processar) }
		return @valores_processados
	end

end



class Neuronio
	
	attr_accessor :conexoes
	attr_accessor :gradiente_local
	attr_accessor :funcao_de_ativacao
	attr_accessor :resposta_da_ativacao
	attr_accessor :derivada_da_ativacao
	
	def initialize(funcao_de_ativacao, conexoes_de_entrada)
		@funcao_de_ativacao = Funcao_de_Ativacao::new(funcao_de_ativacao)
		@conexoes = []
		@somatoria = 0.0
		conexoes_de_entrada.times { @conexoes << Conexao::new() }
		@saida_do_neuronio = 0
		@gradiente_local = 0.0
		@resposta_da_ativacao = 0.0
		@derivada_da_ativacao = 0.0
	end
	
	def processa(valores_para_processar)
		@somatoria = 0.0
		@valores_para_processar = valores_para_processar.dup
		@valores_para_processar.each_with_index do |valor, indice| 
			@conexoes[indice].entrada_da_conexao = valor
			@somatoria += @conexoes[indice].saida_da_conexao
		end
		@resposta_da_ativacao = @funcao_de_ativacao.ativacao(@somatoria)
		@derivada_da_ativacao = @funcao_de_ativacao.derivada(@resposta_da_ativacao)
		puts "  recebi #{valores_para_processar} e respondi #{@resposta_da_ativacao}" if $debug == true
		return  @resposta_da_ativacao
	end

end



class Funcao_de_Ativacao

	attr_accessor :resposta_da_ativacao
	attr_accessor :derivada_da_ativacao

	def initialize(tipo_de_funcao)
		
	end

	def ativacao(valor) 
		return Math.tanh(valor).round(4)
	end

	def derivada(resposta_da_ativacao)
		return (1 - resposta_da_ativacao)**2
	end

end



class Conexao

	attr_accessor :entrada_da_conexao
	attr_accessor :peso_da_conexao
	attr_accessor :parcela_do_erro
	attr_accessor :momentum

	def initialize()
		@entrada_da_conexao = 0
		@peso_da_conexao = rand(-1.0..1.0)
		@parcela_do_erro = 0
		@momentum = 0
	end

	def saida_da_conexao
		return @entrada_da_conexao * @peso_da_conexao
	end

end

@rede = Rede::new([2, 3, 1])
@padrao_de_treinamento = [ [[0, 0], [0]], [[1, 0], [1]], [[0, 1], [1]], [[1, 1], [0]] ]
@rede.treinamento(@padrao_de_treinamento)

#@rede.execucao([ [1, 1], [0, 0], [0, 1], [1, 0] ])
##puts rede.inspect.gsub(" ", "\n")




