Feature: Undo
  Because I am human and make mistakes
  An admin
  Should be able to undo actions they make
  
  @javascript
  Scenario: delete a comment, then undo it
    Given I am logged in
    And the following comment exists:
      | body              |
      | Accidental Delete |
    When I go to /admin
    And I follow "评论管理"
    And I press icon button with title "删除"
    # Not sure why this doesn't redirect automatically
    # And I follow "redirected"
    And I follow "动作"
    And I press icon button with title "还原"
    Then a comment exists with attributes:
      | body              |
      | Accidental Delete |
