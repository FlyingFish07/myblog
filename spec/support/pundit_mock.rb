# for pundit authorize mock
module PunditMock
  def mock_authorize(record, unauthorize: false)
    expectation = expect(controller).to receive(:authorize).with(record)
    expectation.and_raise(Pundit::NotAuthorizedError) if unauthorize

    allow(controller).to receive(:verify_authorized)
  end
  def mock_policy_scope(records)
    expect(controller).to receive(:policy_scope).with(records).and_return(records)
    allow(controller).to receive(:verify_policy_scoped)
  end
end