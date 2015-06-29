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
require 'sinatra'


## Definições: Estes parâmetros serão acessíveis via formulário pelo
# Sinatra
$limite_de_epocas = 2000
$taxa_de_aprendizagem = 0.05
$erro_aceitavel = 0.0001
$taxa_de_momentum = 0.98
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
enable :sessions

## Redireciona para a tela 1
get '/' do
	redirect to '/criar'
end

## A primeira tela, que pede o tamanho da rede
get '/criar' do
	erb :nova_rede
end

## A rede foi criada, agora pede para treinar ou carregar pesos salvos
post '/criar' do
	@formato = params[:formato]
	session[:formato] = @formato.split(",").map {|n| n.to_i}
	session[:rede] = Rede::new(session[:formato])
	erb :rede_criada
end

## treina a rede e mostra o resultado
post '/treinar' do
	@dados_treino = params[:dados_treino]
  puts params
	erb :rede_treinada
end

post '/carregar' do
	@rede = session[:rede]
	puts @rede.carrega(params[:arquivo_de_treino][:tempfile])
	erb :rede_treinada
end

post '/executar' do
	@rede = session[:rede]
	{"dados_execucao"=>"2,1"}
	@entrada = params[:dados_execucao].split(",").collect {|num| num.to_i }
	puts @resposta = @rede.executa(@entrada)
        erb :executar
end

get '/nova_execucao' do
        erb :nova_execucao
end

