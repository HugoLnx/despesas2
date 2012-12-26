# encoding: utf-8
require 'spec_helper'

module Model
  module Temporizacao

    class Ano
      attr_reader :numero

      def initialize(numero)
        @numero = numero
      end

      def <=>(ano)
        @numero <=> ano.numero
      end
    end

    class Mes
      NOMES = %w{janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro}.map(&:to_sym)

      attr_reader :numero

      def initialize(numero)
        @numero = numero
      end

      def nome
        NOMES[@numero-1]
      end

      def <=>(mes)
        @numero <=> mes.numero
      end
    end

    class Anos
      include Enumerable

      def initialize(anos=[])
        @anos = anos.sort
      end

      def push(ano)
        @anos.push(ano)
        @anos.sort!
      end
      alias :<< :push

      def [](numero)
        @anos.find{|ano| ano.numero == numero}
      end

      def each(&block)
        @anos.each(&block)
      end

      def last(*args)
        @anos.last(*args)
      end
    end

    class Meses
      include Enumerable

      def initialize(meses=[])
        @meses = meses.sort
      end

      def push(mes)
        @meses.push(mes)
        @meses.sort!
      end
      alias :<< :push

      def [](numero_ou_nome)
        if numero_ou_nome.is_a? Fixnum
          numero = numero_ou_nome
          @meses.find{|mes| mes.numero == numero}
        else
          nome = numero_ou_nome
          @meses.find{|mes| mes.nome == nome}
        end
      end

      def each(&block)
        @meses.each(&block)
      end

      def last(*args)
        @meses.last(*args)
      end
    end

    FactoryGirl.define do
      factory :ano, class: Ano do
        ignore do
          numero 2012
        end

        initialize_with{ new(numero) }
      end

      factory :mes, class: Mes do
        ignore do
          numero 1
        end

        initialize_with{ new(numero) }
      end

      factory :anos, class: Anos do
      end

      factory :meses, class: Meses do
      end
    end

    describe Meses do
      it 'inserção e recuperação' do
        janeiro = build(:mes, numero: 1)
        fevereiro = build(:mes, numero: 2)
        abril = build(:mes, numero: 4)

        meses = build(:meses)

        meses << janeiro
        meses << abril
        meses << fevereiro

        meses[1].should == janeiro
        meses[:janeiro].should == janeiro

        meses[4].should == abril
        meses[:abril].should == abril
      end

      it 'coleção' do
        meses = build(:meses)

        janeiro = build(:mes, numero: 1)
        fevereiro = build(:mes, numero: 2)
        abril = build(:mes, numero: 4)

        meses << abril
        meses << fevereiro
        meses << janeiro

        ordem_certa = [janeiro, fevereiro, abril]

        meses.each.with_index do |mes, i|
          mes.should == ordem_certa[i]
        end

        meses.first.should == janeiro
        meses.last.should == abril
      end
    end

    describe Anos do
      it 'inserção e recuperação' do
        _2012 = build(:ano, numero: 2012)
        _2013 = build(:ano, numero: 2013)
        anos = build(:anos)

        anos << _2012
        anos << _2013

        anos[2012].should == _2012
        anos[2013].should == _2013
      end

      it 'coleção' do
        _2012 = build(:ano, numero: 2012)
        _2013 = build(:ano, numero: 2013)
        _2014 = build(:ano, numero: 2014)
        anos = build(:anos)

        anos << _2014
        anos << _2013
        anos << _2012

        ordem_certa = [_2012, _2013, _2014]

        anos.each.with_index do |ano, i|
          ano.should == ordem_certa[i]
        end

        anos.first.should == _2012
        anos.last.should == _2014
      end
    end
  end
end
