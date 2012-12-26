# encoding: utf-8
require 'spec_helper'

module Temporizacao
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
