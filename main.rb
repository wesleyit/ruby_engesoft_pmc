#!/usr/bin/env ruby
# Coding: utf-8
# ***********************************************************************
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: OOPMC - Perceptron Multicamadas Orientado a Objetos
# Version: 0.1
# ***********************************************************************
#  
#  Copyright 2014 Wesley Rodrigues da Silva <wesley.it@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  
require './rede.rb'
require './camada.rb'
require './neuronio.rb'
require './conexao.rb'


## Definições: Estes parâmetros serão acessíveis via formulário pelo 
# Sinatra
$limite_de_epocas = 2000
$taxa_de_aprendizagem = 0.05
$erro_aceitavel = 0.0001
$taxa_de_momentum = 0.97
$usar_bias = true
$bias = 1
$range_peso_bias = (-0.5..0.5)
$range_peso_conexao = (-0.5..0.5)
$debug = false
$tipo_de_rede = :hiperbolica
$arredondar_saida = true
$rede_treinada = false
# ***********************************************************************






## Fluxo de Execução ****************************************************
rede = Rede::new([2, 1])

@padrao = [ [[0, 0], [0]], [[0, 1], [1]], [[1, 0], [1]], [[1, 1], [0]] ]
rede.treina(@padrao)
#puts "Salvando os pesos da rede"
#rede.salva('/tmp/rede')
#puts "Carregando os pesos da rede"
#rede.carrega('/tmp/rede')

puts "\n--"
puts "Entrando 0, 0: #{rede.executa([0, 0])}"
puts "Entrando 0, 1: #{rede.executa([0, 1])}"
puts "Entrando 1, 0: #{rede.executa([1, 0])}"
puts "Entrando 1, 1: #{rede.executa([1, 1])}"


