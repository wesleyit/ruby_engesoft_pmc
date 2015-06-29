#!/usr/bin/ruby
# ***********************************************************************
# Coding: utf-8
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: Multilayer Perceptron Implementation in Ruby Language.
#
# ***********************************************************************




## É sempre bom separar as coisas, não é?
puts "\n"




=begin  28/01/2014
	A abordagem padrão bottom-up não funcionou para mim.
	Precisei criar este modelo partindo da rede, depois da camada 
	para finalmente chegar aos neurônios (graças à muito rock n' roll
	e cafeína :)
=end

=begin  29/01/2014
	Estava difícil saber como interligar todos os neurônios. Ei não
	sabia se tratava as conexões como objetos da camada ou da rede.
	Foi então que tive uma ideia: não precisa ter conexões! Afinal, 
	cada neurônio de uma camada vai ter que ter todos os valores da
	saída da camada anterior, logo é muito mais fácil que a camada 
	anterior agrupe todos os seus resultados em um único vetor e 
	que cada neurônio busque esse vetor como seu vetor de entradas.
=end

=begin 30/01/2014
	Decidi usar a função tangente hiperbólica para a ativação.
	Vou criar uma rede que espelha a entrada tipo 12345 54321.
=end


class Neuronio
	attr_accessor :entradas
	attr_accessor :pesos
	attr_accessor :saida

	def initialize()
		@taxa_aprendizado = 0.2
		@entradas = []
		@pesos = []
		@saida = 0.0
		@bias = 1
	end

	def inicia_pesos()
		if @pesos == [] then
			@entradas.each_index do |i|
				@pesos.push(rand(-0.1..0.1))
			end
		end
	end
	
	def ajusta_pesos(erro)
		@pesos.each do |peso|
			erro * (1 - Math.tanh(x)) * (1 + Math.tanh(x))
		end
	end

	def somatoria()
		@soma = 0
		inicia_pesos if @pesos == []
		@entradas.each_index do |i|
			@soma += (@entradas[i] * @pesos[i])
		end
		@soma += @bias
		return @soma
	end

	def funcao_ativacao()
		@saida = Math.tanh(somatoria)
		return @saida
	end
end

class Conexao
        attr_accessor :origem
        attr_accessor :destino
        attr_accessor :peso

	def initialize()
		@origem = []
		@destino = []
		@peso = []
	end
end


class Camada
	attr_accessor :entradas
	attr_accessor :saidas
	attr_accessor :neuronios

	def initialize(tamanho, indice)
		@neuronios = []
		@entradas = []
		tamanho.times {|i| @neuronios.push(Neuronio.new)}
	end

	def processa()
		@saidas = []
		@neuronios.each do |neuronio|
			neuronio.entradas = @entradas
			neuronio.funcao_ativacao
			@saidas.push(neuronio.saida)
		end
		return @saidas
	end
end




class Rede
	def initialize(entradas)
		puts "----------------------------------------------------------------------------"
		## Inicializa em branco as principais variáveis
		@saida = []
		@tamanho = entradas.length
		@camadas = []
		@qtd_neuronios = 0
		@qtd_camadas = 0 
		@todas_conexoes = Conexao.new()

		## O loop percorre os parâmetros, cria as camadas e 
		# incrementa os contadores
		entradas.each do |i|
			@camadas.push(Camada.new(i,@qtd_camadas))
			@qtd_camadas += 1
			@qtd_neuronios += i
		end

		## Conecta os neuronios em todas as camadas
		@conexoes = 0
                @camadas.each_index do |camada|
                        next if camada == @tamanho-1
			puts " + Conectando os neuronios da camada #{camada+1} com os da #{camada + 2}"
			@camadas[camada].neuronios.each do |neuronio1|
				@camadas[camada + 1].neuronios.each do |neuronio2|
					puts "   - conectando o #{neuronio1} com o #{neuronio2}"
					@todas_conexoes.origem.push(neuronio1)
					@todas_conexoes.destino.push(neuronio2)
					@todas_conexoes.peso.push(rand(-0.1..0.1))
					@conexoes += 1
				end
			end
                end
		puts "#{@conexoes} conexoes criadas"
		puts "Origem: #{@todas_conexoes.origem.display}"
		puts "Destino: #{@todas_conexoes.destino.display}"
		puts "Peso: #{@todas_conexoes.peso.display}"
		puts "Criação da rede concluída. Dados: #{@qtd_camadas} camadas, total de #{@qtd_neuronios} neurônios."
		puts "----------------------------------------------------------------------------\n"
	end


	def executa(entradas)
		@camadas[0].entradas = entradas
		@camadas.each_index do |camada|
			next if camada == 0
			next if camada == @tamanho 
			@camadas[camada].entradas = @camadas[camada - 1].processa
		end
		@saida = @camadas[@tamanho - 1].processa
                puts "Saída = #{@saida}"
	end

        def treina(entradas, esperados)
                @camadas[0].entradas = entradas
                @camadas.each_index do |camada|
                        next if camada == 0
                        next if camada == @tamanho
                        @camadas[camada].entradas = @camadas[camada - 1].processa
                end
                @saida = @camadas[@tamanho - 1].processa
		@erro = []
		@erro_arredondado = []
		@saida_arredondada = []
		esperados.each_index do |i|
			@saida_arredondada[i] = @saida[i].round 
			@erro_arredondado[i] = esperados[i] - @saida_arredondada[i]
			@erro[i] = esperados[i] - @saida[i]
		end
                puts "Saída = #{@saida_arredondada}, Erro = #{@erro_arredondado}"
        end


end

rede = Rede.new([10, 8, 6, 4, 2, 1])


#rede1 = Rede.new([8, 16, 8])
#rede1.treina([8, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1])
#rede1.treina([8, 8, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 1])
#rede1.treina([8, 8, 8, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 1, 1, 1])
#rede1.treina([8, 8, 8, 8, 0, 0, 0, 0], [0, 0, 0, 0, 1, 1, 1, 1])
#rede1.treina([8, 8, 8, 8, 8, 8, 8, 8], [1, 1, 1, 1, 1, 1, 1, 1])








puts "\n"
