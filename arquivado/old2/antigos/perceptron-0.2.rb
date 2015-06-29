#!/usr/bin/ruby
# ***********************************************************************
# Coding: utf-8
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: Multilayer Perceptron Implementation in Ruby Language.
# Version: 0.2
# ***********************************************************************
puts "\n\n"


class Neuronio
	attr_accessor :entradas
	attr_accessor :saida
	attr_accessor :gradiente
	attr_accessor :pesos

	def initialize(id, id_camada, conexoes, entradas)
		@id = id
		@gradiente = 0
		@id_camada = id_camada
		@bias = 1.0
		@taxa_aprendizado = 1.3
		@entradas = entradas.dup
		@pesos = conexoes.dup
		@saida = 0.0
		define_pesos_randomicos
	end

	def define_pesos_randomicos
		@pesos.each_index do |p|
			@pesos[p] = rand(0.1..0.9)
		end
	end

	def executa
		return ativacao(somatoria)
	end

	def somatoria
		@soma = 0.0
		@entradas.each_with_index do |e, i|
			@soma += e * @pesos[i]
		end
		@soma += @bias
		puts "Camada=#{@id_camada}, Neuronio=#{@d}, Pesos=#{@pesos}, Somatoria=#{@soma}"
		return @soma
	end
	

	def ativacao(valor)
		return Math.tanh(valor)
	end
	
	def delta_peso_saida(erro, peso, entrada) 
		calcula_gradiente(erro, entrada)
		return @taxa_aprendizado * @gradiente * entrada
	end

	def delta_peso_ocultas(fator, entrada)
                return @taxa_aprendizado * fator * entrada
	end

	def calcula_gradiente(erro, entrada)
		@gradiente = erro * derivada_ativacao(entrada)
		return @gradiente
	end

	def derivada_ativacao(entrada)
		return 1 - Math.tanh(entrada) ** 2
	end

	def propaga_ajustes
	end

	def ajusta_pesos_saida(erro)
		@pesos.each_index do |i|
			@pesos[i] += delta_peso_saida(erro, @pesos[i], @entradas[i])
		end
		puts "Ajustando os pesos para #{@pesos}"
	end

	##fator é o gradiente da camada à direita x o peso dessa conexao
        def ajusta_pesos_ocultas(fator) 
		puts "Pesos antigos do Neuronio #{@id}: #{@pesos}"
                @pesos.each_index do |i|
                        @pesos[i] += delta_peso_ocultas(fator, @entradas[i])
                end
		puts "Pesos novos do Neuronio #{@id}: #{@pesos}\n\n"
        end

end





class Camada
	attr_accessor :entradas
	attr_accessor :saidas
	attr_accessor :neuronios

	def initialize(id, entradas, conexoes)	
		@id = id
		@conexoes = conexoes
		@neuronios = []
		@entradas = entradas
		@saidas = []
		popular_camadas
	end

	def popular_camadas
		@entradas.each_index do |i|
			@neuronios.push(Neuronio::new(i, @id, @conexoes, @entradas))
		end
	end

	def executa
		@saidas = []
		@neuronios.each_index do |n|
			@neuronios[n].entradas = @entradas
			@saidas.push(@neuronios[n].executa)
		end
	end
end





class Rede
	def initialize(dimensao)
		@dimensao = dimensao
		@camadas = []
		@entradas = []
		@saidas = []
		adicionar_camadas
	end

	def adicionar_camadas
		@dimensao.each_index do |i|
			@camadas.push(Camada::new(i, Array.new(@dimensao[i]), Array.new(@dimensao[i]))) if i == 0
			@camadas.push(Camada::new(i, Array.new(@dimensao[i]), Array.new(@dimensao[i - 1]))) if i > 0
		end
	end

	def executa(parametro)
		@entradas = parametro
		puts "\n==============================================================================================================\n\n"
		puts "Executando a rede neural com os parâmetros #{@entradas}:"
		@camadas.each_index do |c|
			@camadas[c].entradas = @entradas if c == 0
			@camadas[c].entradas = @camadas[c-1].saidas if c > 0
			@camadas[c].executa

		end
		@saidas = @camadas.last.saidas
		puts @saidas
		return @saidas
	end

	def treina(padrao, iteracoes)
		@padrao = padrao
		@iteracoes = iteracoes
		@erro = []
		@erro_quadratico = []
		@obtido = []
		@esperado = []


		iteracoes.times do |epoca|
			@padrao.each_index do |p|
				puts "\n==============================================================================================================\n\n"
				puts "Treinando a rede para receber #{@padrao[p][0]} e responder #{@padrao[p][1]}"
				@obtido[p] = executa(@padrao[p][0])
				@esperado[p] = @padrao[p][1]
				@erro = @esperado[p].zip(@obtido[p]).map {|e, o| e - o}
				@erro_quadratico = @esperado[p].zip(@obtido[p]).map {|e, o| 0.5 * (e - o) ** 2}
				puts "Erro: #{@erro}, Erro quadratico = #{@erro_quadratico}, "


				## AQUI A MAGICA ACONTECE! BACKPROPAGATION MESMO!!!
				@camadas.reverse.each_index do |c|
					if c == @camadas.length
						puts "Vou morrer"
						@erro.each_with_index do |erro, i|
							@ajuste = @camadas[c].neuronios[i].ajusta_pesos_saida(erro)
						end
						next
					end
					@fator = 0
					@camadas[c].neuronios.each_with_index do |neuronio, ni|
						@gradientes_direita = []
						@camadas[c + 1].neuronios.each do |n_direita|
							@fator += n_direita.gradiente * n_direita.pesos[ni]
						end
					neuronio.ajusta_pesos_ocultas(@fator)
					end
				end

			end
			@soma_erro_quadratico = 0
			@erro_quadratico.each_index do |eq|
				@soma_erro_quadratico += @erro_quadratico[eq]
			end
			puts "Soma Erro quadratico = #{@soma_erro_quadratico}"
			puts "Media Erro quadratico = #{@soma_erro_quadratico / @erro_quadratico.length}"
		end
	end
end




rede = Rede::new([2,3,1])
#puts rede.executa([100,100,100])
#puts rede.executa([10000,10000,10000])
#puts rede.executa([-1001,-10001,-11])

XOR = [[[0, 0], [0]], [[0, 1], [1]], [[1, 0], [1]], [[1, 1], [0]]]
rede.treina(XOR, 1)

#puts "\n\n\n ************** AGORA É PRA VALER! ******************\n\n"
#rede.executa([0, 0])
#rede.executa([0, 1])
#rede.executa([1, 0])
#rede.executa([1, 1])



puts "\n\n"


