require_relative 'spec_helper'
require_relative '../lib/zest-publisher/nodes'

shared_context "shared render" do
  before(:each) do
    @null = Zest::Nodes::NullLiteral.new
    @what_is_your_quest = Zest::Nodes::StringLiteral.new("What is your quest ?")
    @fighters = Zest::Nodes::StringLiteral.new('fighters')
    @pi = Zest::Nodes::NumericLiteral.new('3.14')
    @false = Zest::Nodes::BooleanLiteral.new(false)
    @true = Zest::Nodes::BooleanLiteral.new(true)
    @foo_variable = Zest::Nodes::Variable.new('foo')
    @foo_bar_variable = Zest::Nodes::Variable.new('foo bar')
    @x_variable = Zest::Nodes::Variable.new('x')

    @foo_fighters_prop = Zest::Nodes::Property.new(@foo_variable, @fighters)
    @foo_dot_fighters = Zest::Nodes::Field.new(@foo_variable, 'fighters')
    @foo_brackets_fighters = Zest::Nodes::Index.new(@foo_variable, @fighters)
    @foo_minus_fighters = Zest::Nodes::BinaryExpression.new(@foo_variable, '-', @fighters)
    @minus_foo = Zest::Nodes::UnaryExpression.new('-', @foo_variable)
    @parenthesis_foo = Zest::Nodes::Parenthesis.new(@foo_variable)

    @foo_list = Zest::Nodes::List.new([@foo_variable, @fighters])
    @foo_dict =  Zest::Nodes::Dict.new([@foo_fighters_prop,
      Zest::Nodes::Property.new('Alt', 'J')
    ])

    @simple_template = Zest::Nodes::Template.new([
      Zest::Nodes::StringLiteral.new('A simple template')
    ])

    @foo_template = Zest::Nodes::Template.new([@foo_variable, @fighters])
    @double_quotes_template = Zest::Nodes::Template.new([
      Zest::Nodes::StringLiteral.new('Fighters said "Foo !"')
    ])

    @assign_fighters_to_foo = Zest::Nodes::Assign.new(@foo_variable, @fighters)
    @assign_foo_to_fighters = Zest::Nodes::Assign.new(
      Zest::Nodes::Variable.new('fighters'),
      Zest::Nodes::StringLiteral.new('foo'))
    @call_foo = Zest::Nodes::Call.new('foo')
    @call_foo_bar = Zest::Nodes::Call.new('foo bar')
    @argument = Zest::Nodes::Argument.new('x', @fighters)
    @call_foo_with_fighters = Zest::Nodes::Call.new('foo', [@argument])
    @call_foo_bar_with_fighters = Zest::Nodes::Call.new('foo bar', [@argument])

    @simple_tag = Zest::Nodes::Tag.new('myTag')
    @valued_tag = Zest::Nodes::Tag.new('myTag', 'somevalue')

    @plic_param = Zest::Nodes::Parameter.new('plic')
    @x_param = Zest::Nodes::Parameter.new('x')
    @plic_param_default_ploc = Zest::Nodes::Parameter.new(
      'plic',
      Zest::Nodes::StringLiteral.new('ploc'))
    @flip_param_default_flap = Zest::Nodes::Parameter.new(
      'flip',
      Zest::Nodes::StringLiteral.new('flap'))

    @action_foo_fighters = Zest::Nodes::Step.new('action', @foo_template)

    @if_then = Zest::Nodes::IfThen.new(@true, [@assign_fighters_to_foo])
    @if_then_else = Zest::Nodes::IfThen.new(
      @true, [@assign_fighters_to_foo], [@assign_foo_to_fighters])
    @while_loop = Zest::Nodes::While.new(
      @foo_variable,
      [
        @assign_foo_to_fighters,
        @call_foo_with_fighters
      ])

    @empty_action_word = Zest::Nodes::Actionword.new('my action word')
    @tagged_action_word = Zest::Nodes::Actionword.new(
      'my action word',
      [@simple_tag, @valued_tag])
    @parameterized_action_word = Zest::Nodes::Actionword.new(
      'my action word',
      [],
      [@plic_param, @flip_param_default_flap])

    full_body = [
      Zest::Nodes::Assign.new(@foo_variable, @pi),
      Zest::Nodes::IfThen.new(
        Zest::Nodes::BinaryExpression.new(
          @foo_variable,
          '>',
          @x_variable),
        [
          Zest::Nodes::Step.new('result', "x is greater than Pi")
        ],
        [
          Zest::Nodes::Step.new('result', "x is lower than Pi\n on two lines")
        ])
      ]

    @full_actionword = Zest::Nodes::Actionword.new(
      'compare to pi',
      [@simple_tag],
      [@x_param],
      full_body)

    @step_action_word = Zest::Nodes::Actionword.new(
      'my action word',
      [],
      [],
      [Zest::Nodes::Step.new('action', "basic action")])

    @full_scenario = Zest::Nodes::Scenario.new(
      'compare to pi',
       "This is a scenario which description \nis on two lines",
      [@simple_tag],
      [@x_param],
      full_body)

    @actionwords = Zest::Nodes::Actionwords.new([
      Zest::Nodes::Actionword.new('first action word'),
      Zest::Nodes::Actionword.new(
        'second action word', [], [], [
          Zest::Nodes::Call.new('first action word')
        ])
    ])
    @scenarios = Zest::Nodes::Scenarios.new([
      Zest::Nodes::Scenario.new('first scenario'),
      Zest::Nodes::Scenario.new(
        'second scenario', '', [], [], [
          Zest::Nodes::Call.new('my action word')
        ])
    ])
    @scenarios.parent = Zest::Nodes::Project.new('My_project')

    @actionwords_with_paramters = Zest::Nodes::Actionwords.new([
      Zest::Nodes::Actionword.new('aw with int param', [], [Zest::Nodes::Parameter.new('x')], []),
      Zest::Nodes::Actionword.new('aw with float param', [], [Zest::Nodes::Parameter.new('x')], []),
      Zest::Nodes::Actionword.new('aw with boolean param', [], [Zest::Nodes::Parameter.new('x')], []),
      Zest::Nodes::Actionword.new('aw with null param', [], [Zest::Nodes::Parameter.new('x')], []),
      Zest::Nodes::Actionword.new('aw with string param', [], [Zest::Nodes::Parameter.new('x')], []),
      Zest::Nodes::Actionword.new('aw with template param', [], [Zest::Nodes::Parameter.new('x')], [])
    ])
    @scenarios_with_many_calls = Zest::Nodes::Scenarios.new([
      Zest::Nodes::Scenario.new('many calls scenarios', '', [], [], [
        Zest::Nodes::Call.new('aw with int param', [
          Zest::Nodes::Argument.new('x', Zest::Nodes::NumericLiteral.new('3'))]),
        Zest::Nodes::Call.new('aw with float param', [
          Zest::Nodes::Argument.new('x',
            Zest::Nodes::NumericLiteral.new('4.2')
          )]),
        Zest::Nodes::Call.new('aw with boolean param', [
          Zest::Nodes::Argument.new('x',
            Zest::Nodes::BooleanLiteral.new(true)
          )]),
        Zest::Nodes::Call.new('aw_with_null_param', [
          Zest::Nodes::Argument.new('x',
            Zest::Nodes::NullLiteral.new
          )]),
        Zest::Nodes::Call.new('aw with string param', [
          Zest::Nodes::Argument.new('x', Zest::Nodes::StringLiteral.new('toto'))]),
        Zest::Nodes::Call.new('aw with string param', [
          Zest::Nodes::Argument.new('x', Zest::Nodes::Template.new(Zest::Nodes::StringLiteral.new('toto')))])
      ])])
    @project = Zest::Nodes::Project.new('My project', "", @scenarios_with_many_calls, @actionwords_with_paramters)

    @context = {framework: framework}
  end
end

shared_examples "a renderer" do
  it 'NullLiteral' do
    expect(@null.render(language, @context)).to eq(@null_rendered)
  end

  it 'StringLiteral' do
    expect(@what_is_your_quest.render(language, @context)).to eq(@what_is_your_quest_rendered)
  end

  it 'NumericLiteral' do
    expect(@pi.render(language, @context)).to eq(@pi_rendered)
  end

  it 'BooleanLiteral' do
    expect(@false.render(language, @context)).to eq(@false_rendered)
  end

  it 'Variable' do
    expect(@foo_variable.render(language, @context)).to eq(@foo_variable_rendered)
  end

  it 'Variable' do
    expect(@foo_variable.render(language, @context)).to eq(@foo_variable_rendered)
    expect(@foo_bar_variable.render(language, @context)).to eq(@foo_bar_variable_rendered)
  end

  it 'Property' do
    expect(@foo_fighters_prop.render(language, @context)).to eq(@foo_fighters_prop_rendered)
  end

  it 'Field' do
    expect(@foo_dot_fighters.render(language, @context)).to eq(@foo_dot_fighters_rendered)
  end

  it 'Index' do
    expect(@foo_brackets_fighters.render(language, @context)).to eq(@foo_brackets_fighters_rendered)
  end

  it 'BinaryExpression' do
    expect(@foo_minus_fighters.render(language, @context)).to eq(@foo_minus_fighters_rendered)
  end

  it 'UnaryExpression' do
    expect(@minus_foo.render(language, @context)).to eq(@minus_foo_rendered)
  end

  it 'Parenthesis' do
    expect(@parenthesis_foo.render(language, @context)).to eq(@parenthesis_foo_rendered)
  end

  it 'List' do
    expect(@foo_list.render(language, @context)).to eq(@foo_list_rendered)
  end

  it 'Dict' do
    expect(@foo_dict.render(language, @context)).to eq(@foo_dict_rendered)
  end

  it 'Template' do
    expect(@foo_template.render(language, @context)).to eq(@foo_template_rendered)
    expect(@double_quotes_template.render(language, @context)).to eq(@double_quotes_template_rendered)
  end

  it 'Assign' do
    expect(@assign_fighters_to_foo.render(language, @context)).to eq(@assign_fighters_to_foo_rendered)
  end

  it 'Call' do
    expect(@call_foo.render(language, @context)).to eq(@call_foo_rendered)
    expect(@call_foo_bar.render(language, @context)).to eq(@call_foo_bar_rendered)
    expect(@call_foo_with_fighters.render(language, @context)).to eq(@call_foo_with_fighters_rendered)
    expect(@call_foo_bar_with_fighters.render(language, @context)).to eq(@call_foo_bar_with_fighters_rendered)
  end

  it 'IfThen' do
    expect(@if_then.render(language, @context)).to eq(@if_then_rendered)
    expect(@if_then_else.render(language, @context)).to eq(@if_then_else_rendered)
  end

  it "Step" do
    expect(@action_foo_fighters.render(language, @context)).to eq(@action_foo_fighters_rendered)
  end

  it 'While' do
    expect(@while_loop.render(language, @context)).to eq(@while_loop_rendered)
  end

  it 'Tag' do
    expect(@simple_tag.render(language, @context)).to eq(@simple_tag_rendered)
    expect(@valued_tag.render(language, @context)).to eq(@valued_tag_rendered)
  end

  it 'Parameter' do
    expect(@plic_param.render(language, @context)).to eq(@plic_param_rendered)
    expect(@plic_param_default_ploc.render(language, @context)).to eq(@plic_param_default_ploc_rendered)
  end

  context 'Actionword' do
    it 'empty' do
      expect(@empty_action_word.render(language, @context)).to eq(@empty_action_word_rendered)
    end

    it 'with tags' do
      expect(@tagged_action_word.render(language, @context)).to eq(@tagged_action_word_rendered)
    end

    it 'with parameters' do
      expect(@parameterized_action_word.render(language, @context)).to eq(@parameterized_action_word_rendered)
    end

    it 'with body' do
      expect(@full_actionword.render(language, @context)).to eq(@full_actionword_rendered)
    end

    it 'with body that contains only step' do
      expect(@step_action_word.render(language, @context)).to eq(@step_action_word_rendered)
    end
  end

  it 'Scenario' do
    expect(@full_scenario.render(language, @context)).to eq(@full_scenario_rendered)
  end

  it 'Actionwords' do
    @context[:package] = 'com.example'
    expect(@actionwords.render(language, @context)).to eq(@actionwords_rendered)
  end

  it 'Actionwords with parameters of different types' do
    @context[:package] = 'com.example'
    Zest::Nodes::ParameterTypeAdder.add(@project)
    expect(@project.childs[:actionwords].render(language, @context)).to eq(@actionwords_with_params_rendered)
  end

  it 'Scenarios' do
    @context[:filename] = 'ProjectTest.java'
    @context[:package] = 'com.example'
    @context[:call_prefix] = 'actionwords'
    expect(@scenarios.render(language, @context)).to eq(@scenarios_rendered)
  end
end