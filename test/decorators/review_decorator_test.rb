require 'test_helper'

class ReviewDecoratorTest < ActiveSupport::TestCase
  def setup
    @review = Review.new.extend ReviewDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
