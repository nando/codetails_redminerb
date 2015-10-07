# encoding: utf-8
center <<-EOS
  \e[1mredminerb\e[0m
  ┌─────────────────────────────┐
  │ A  R.E.S.T.  A.P.I.  C.L.I. │
  └─────────────────────────────┘

  nando @colgado_es
  © The Cocktail Codetails 2015
EOS

block <<-EOS
   Prólogo________________________g+2
  ────────────────────────────────────
   1.- RDD: README first_________g+10
   2.- WhatIs\e[1mThor\e[0m.com____________g+29
   3.- Redminerb's Thor__________g+35
   4.- Testing Faraday...________g+39
   5.- Surprise, surprise._______g+43
  ────────────────────────────────────
   Epílogo_______________________g+55
EOS

center <<-EOS
  ┌────────────────┐
  │     PRÓLOGO    │
  └────────────────┘
EOS

block <<-EOS
  Brenes en Slack:

  — \e[1m¿Grabáis los Codetails?\e[0m
EOS
center <<-EOS
  Reflexión personal...
EOS
center <<-EOS
  Codetails...

  \e[1mmenos personales\e[0m
EOS

center <<-EOS
  Codetails...

  \e[1mmenos filosóficos\e[0m
EOS

center <<-EOS
  Codetails...

  \e[1m¡TÉCNICOS!\e[0m
EOS

center <<-EOS
  ...y lo otro \e[1mcuando queráis\e[0m.

  (en persona o por Slack)
EOS

section "* \e[1mRDD: README first\e[0m *" do
  center 'http://github.com/nando/redminerb'
  center 'Redminerb es un proyecto RDD'
  center "Tom Preston Werner's\n\nReadme Driven Development"

  block <<-EOS
    Configuration:
      * \e[1mURL\e[0m & \e[1mAPI-Key\e[0m:

    Dos opciones:
      - en \e[1m~/.redminerb.yml\e[0m
      - en \e[1mvariables de entorno\e[0m
  EOS

  code "$ redminerb \e[1mconfig\e[0m"

  code "$ redminerb \e[1musers\e[0m"

  code "$ redminerb users \e[1m--fields id:login\e[0m"

  code "$ redminerb users \e[1mme\e[0m"

  code "$ redminerb users \e[1m--query leon\e[0m"

  code "$ redminerb users \e[1m--limit 4 --offset 17\e[0m"

  code "$ redminerb users \e[1m-q ale -o 2 -l 4\e[0m"

  code "$ redminerb users \e[1m398\e[0m"

  code <<-EOS
    $ redminerb users show 398 \\
    > \e[1m--template user_in_a_box\e[0m
  EOS

  center <<-EOS
    \e[1muser_in_a_box\e[0m == "built-in" template
  EOS

  block <<-EOS
    Custom templates in:
    1.- current directory,
    2.- home
  EOS

  code <<-EOS
    $ ls -la ~/.redminerb/templates
    \e[1missue.erb issue_codetails.erb  user_codetails.erb\e[0m
  EOS

  code <<-EOS
    $ redminerb users show 398 \\
    > \e[1m--template user_codetails\e[0m
  EOS

  code <<-EOS
    $ redminerb users create --login wadus [...]
  EOS

end

section "* WhatIs\e[1mThor\e[0m.com *" do
  block <<-EOS
    * Gema para definir la interfaz del comando.
    * Usada en \e[1mpantulis/tacoma\e[0m y \e[1mtheistian/restminer\e[0m
    * Autor: Yehuda Kats
    * Otras alternativas: \e[1mGLI\e[0m, \e[1mmain\e[0m, OptionParser, etc.
  EOS
  
  code <<-EOS
    require "thor"
    class MyCLI < Thor
      desc "hello NAME", "say hello to NAME"
      def hello(name)
        puts "Hello \#{name}!"
      end
    end
    MyCLI.start(ARGV)

    $ mycli hello "RubyRoom!"
    Hello RubyRoom!
  EOS

  code <<-EOS
    \e[1mSUBCOMMANDS\e[0m
  EOS

  code <<-EOS
    class Goodbyes < Thor
      def chao(name)
        puts "Chao \#{name}! :("
      end
    end
    class MyCLI < Thor
      [...]
      subcommand "goodbyes", Goodbyes
    end
  EOS

  code <<-EOS
    $ mycli goodbyes chao "Alex!"
    Chao Alex! :(
  EOS
end

section "* Redminerb's Thor *" do
  code <<-EOS
    # lib/redminerb/cli.rb
    require_relative 'cli/users'
    require_relative 'cli/issues'
    module Redminerb
      class CLI < Thor
        [...]
        subcommand 'users', Cli::Users
        subcommand 'issues', Cli::Issues
      end
    end
  EOS

  block <<-EOS
    # lib/redminerb/cli/users.rb
    class Users < Thor
      \e[1mdefault_command :list\e[0m   # \e[1mlist\e[0m es el subcomando por defecto
      [...]
      def list(user_id\e[1m = nil\e[0m) #\e[1m PERO CON PARÁMETRO OPCIONAL\e[0m
        if user_id            #   y si lo tenemos...
          show user_id        # \e[1m¡lanzamos el subcomando show!\e[0m
        else
          Redminerb.init!
          fields = options.delete(:fields) || 'id:login:mail'
          \e[1mRedminerb::Users.list\e[0m(options).each do |user|
            puts fields.split(':').map {|f| user.send(f)}.join("\\t")
          end
        end
      end
      def show(user_id)
        [...]
      end
    end
  EOS

  code <<-EOS
    # lib/redminerb/users.rb
    module Redminerb
      class Users 
        class << self
          def list(params)
            Redminerb.client.get_json('/users.json', params)['users'].map do |user|
              OpenStruct.new user
            end
          end
        end
      end
    end
  EOS
end

section "* \e[1mTesting Faraday...\e[0m *" do
  center <<-EOS
    But... Faraday have its own tests!

    Much better \e[1man integration test\e[0m

    (me estaba complicando, ¡gracias Rossi!)
  EOS

  block <<-EOS
    \e[1mspec/redminerb/cli_spec.rb\e[0m
  EOS

  code <<-EOS
    describe Redminerb::CLI do
      subject { Redminerb::CLI.new }
        describe 'users command' do
          describe 'list subcommand' do
            before { VCR.insert_cassette 'users_list' }
            after  { VCR.eject_cassette }

            let(:output) do
              capture(:stdout) { subject.users 'list' }
            end

            it 'give us all the users in our Redmine', :vcr do
              output.must_include "\\tnando\\t"
            end
          end
        end
      end
    end
  EOS
end
section "* \e[1mSurprise, surprise.\e[0m *" do
  block <<-EOS
    Thor plays well with others:
  EOS
  center <<-EOS
    \e[1m0\e[0m means \e[1mGOOD\e[0m
    because
    \e[1mexit code matters\e[0m
  EOS
  center "\e[1mredminerb\e[0m tries to do the same..."
  center "so \e[1mit fails\e[0m when things doesn't work"
  center "nice surprise :)"
  code <<-EOS
    $ redminerb \e[1muser\e[0m 398 # \e[1mWORKS!!!\e[0m

    # NOTICE the singular
  EOS
  center "bad surprises"
  code "$ redminerb users \e[1mhelp show\e[0m"
  center "Doesn't show the command... :("
  code "$ redminerb users create \e[1m-l mylogin --password...\e[0m"
  center "Aliases aren't working well :("
end

center <<-EOS
  ┌───────────────┐
  │    EPÍLOGO    │
  └───────────────┘
EOS

center <<-EOS
  ¿is Ruby dying?

  \e[1mlove\e[0m and \e[1mfun\e[0m also matters
EOS

center <<-EOS
  \e[1m¡GRACIAS!\e[0m
EOS
# Copyright 2015 The Cocktail Experience, S.L.
