mod = angular.module 'deskquiz.quiz', []

angularCode = """
angular.module('myModule').service('myService', function() {
  var message = "Message one!"
  var getMessage = function() {
    return this.message
  }
  this.message = "Message two!"
  this.getMessage = function() { return message }
  function() {
    {
      getMessage: getMessage,
      message: "Message three!"
    }
  }
}
"""

mod.factory 'quiz', ->
  correctMultipleChoice = (question) ->
    question.answers[question.input]?.correct == true

  correctFillInBlank = (question) ->
    for answer, index in question.input
      return false unless answer in question.answers[index]
    true

  correctAnswerChosen: (question) ->
    switch question.type
      when 'multiple_choice' then correctMultipleChoice(question)
      when 'fill_in_blank' then correctFillInBlank(question)

  questionsCorrect: (questions) ->
    correct = questions
      .map(@correctAnswerChosen.bind(this))
      .filter((val) -> val == true)
      .length

  reviewing: false
  questions: [
    {
      text: "Which is not an advantage of using a closure?"
      type: 'multiple_choice'
      answers: [
        { text: 'a. Prevent pollution of global scope', correct: false }
        { text: 'b. Encapsulation', correct: false }
        { text: 'c. Private properties and methods', correct: false }
        { text: 'd. Allow conditional use of "strict mode"', correct: true }
      ]
      answerText: 'd.'
      explanation: """Conditional use of "strict mode" can be used in
        functions without using a closure."""
      input: null
    }

    {
      text: """To create a columned list of two-line email subjects and dates
        for a master-detail view, which are the most semantically correct?"""
      type: 'multiple_choice'
      answers: [
        { text: 'a. <div>+<span>', correct: false }
        { text: 'b. <tr>+<td>', correct: true }
        { text: 'c. <ul>+<li>', correct: false }
        { text: 'd. <p>+<br>', correct: false }
        { text: 'e. none of these', correct: false }
        { text: 'f. all of these', correct: false }
      ]
      answerText: 'b.'
      explanation: """Since the data being displayed is actual tabular
        data and not a list, a table is semantically correct."""
      input: null
    }

    {
      text: 'To pass an array of strings to a function, you should not use...'
      type: 'multiple_choice'
      answers: [
        { text: 'a. fn.apply(this, stringsArray)', correct: false }
        { text: 'b. fn.call(this, stringsArray)', correct: false }
        { text: 'c. fn.bind(this, stringsArray)', correct: true }
      ]
      answerText: 'c.'
      explanation: """Use fn.apply to pass the array as a single argument;
        use fn.call to pass each element of the array as a separate argument.
        fn.bind returns a new function with the array pre-bound as the
        first argument."""
      input: null
    }

    {
      text: """______ and ______ would be the HTML tags you would use to display
        a menu item and its description."""
      type: 'fill_in_blank'
      answers: [
        [ 'menu', '<menu>' ]
        [ 'menuitem', '<menuitem>' ]
      ]
      answerText: 'menu & menuitem'
      explanation: """<tt>menu</tt> and <tt>menuitem</tt> are semantic HTML5 tags to display
        menus and menu items; see
        http://www.whatwg.org/specs/web-apps/current-work/multipage/interactive-elements.html"""
      input: [ null, null ]
    }

    {
      text: """Given &lt;div id="outer">&lt;div class="inner">&lt;div>&lt;div>,
        which of these two is the most performant way to select the inner div?"""
      type: 'multiple_choice'
      answers: [
        { text: 'a. getElementById("outer").children[0]', correct: false }
        { text: 'b. getElementsByClassName("inner")[0]', correct: true }
      ]
      answerText: 'b.'
      explanation: """Performance tests show that getElementsByClassName is generally
        faster than getElementById in most modern browsers. See
        http://jsperf.com/getelementbyid-vs-queryselector/25"""
      input: null
    }

    {
      text: """Given this:
        <pre>#{angularCode}</pre>
        Which message will be returned by injecting this service and executing
        \"myService.getMessage()\"
      """
      type: 'multiple_choice'
      answers: [
        { text: 'a. 1', correct: true }
        { text: 'b. 2', correct: false }
        { text: 'c. 3', correct: false }
      ]
      answerText: 'a.'
      explanation: """Angular services created with `service` register a constructor
        function that is used to instantiate the injected variable; thus, the
        injected `myService` is an instance of the constructor function. Since
        `this.getMessage` was set to return the local variable `message`, "Message one!"
        will be returned. (All this assuming this JavaScript was legal. :)"""
      input: null
    }
  ]
