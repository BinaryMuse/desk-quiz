#= require angular
#= require angular-mocks
#= require deskquiz.quiz

describe 'the deskquiz.quiz module', ->
  beforeEach module('deskquiz.quiz')

  describe 'correctAnswerChosen', ->
    describe 'for a multiple choice question', ->
      [question] = [undefined]

      beforeEach ->
        question =
          text: 'What is your favorite color?'
          type: 'multiple_choice'
          answers: [
            { text: 'a. Blue', correct: true }
            { text: 'b. I mean yellow', correct: false }
          ]
          answerText: 'a.'
          explanation: "You have to know these things when you're a king, you know."
          input: null

      it "returns true when the user selects the correct answer", inject (quiz) ->
        question.input = 0
        expect(quiz.correctAnswerChosen(question)).toEqual(true)

      it "returns false when the user selects an incorrect answer", inject (quiz) ->
        question.input = 1
        expect(quiz.correctAnswerChosen(question)).toEqual(false)

    describe 'for a fill-in-the-blank question', ->
      [question] = [undefined]

      beforeEach ->
        question =
          text: 'What is the air-speed velocity of an unladen swallow? ___ or ___?'
          type: 'fill_in_blank'
          answers: [
            [ 'african', 'African' ]
            [ 'european', 'European' ]
          ]
          answerText: 'African & European'
          explanation: "You have to know these things when you're a king, you know."
          input: [ null, null ]

      it "returns true when the user enters all the correct answers", inject (quiz) ->
        question.input = [ 'african', 'european' ]
        expect(quiz.correctAnswerChosen(question)).toEqual(true)
        question.input = [ 'African', 'European' ]
        expect(quiz.correctAnswerChosen(question)).toEqual(true)

      it "returns false when the user enters any incorrect answer", inject (quiz) ->
        question.input = [ 'hawaiian', 'european' ]
        expect(quiz.correctAnswerChosen(question)).toEqual(false)

    describe 'questionsCorrect', ->
      [questions] = [undefined]

      beforeEach ->
        question1 =
          text: 'What is your favorite color?'
          type: 'multiple_choice'
          answers: [
            { text: 'a. Blue', correct: true }
            { text: 'b. I mean yellow', correct: false }
          ]
          answerText: 'a.'
          explanation: "You have to know these things when you're a king, you know."
          input: 0

        question2 =
          text: 'What is the air-speed velocity of an unladen swallow? ___ or ___?'
          type: 'fill_in_blank'
          answers: [
            [ 'african', 'African' ]
            [ 'european', 'European' ]
          ]
          answerText: 'African & European'
          explanation: "You have to know these things when you're a king, you know."
          input: [ 'wrong', 'wronger' ]

        questions = [question1, question2]

      it "returns how many questions the user got correct", inject (quiz) ->
        expect(quiz.questionsCorrect(questions)).toEqual(1)
