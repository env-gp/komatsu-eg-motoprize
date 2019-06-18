module ReviewDecorator

  STATUS = {Review::STATUS_PUBLISH => 'レビューを投稿する', Review::STATUS_DRAFT => '下書き保存する' }
  STATUS_NAME = {Review::STATUS_PUBLISH => '公開済み', Review::STATUS_DRAFT => '下書き' }

  def get_uses
    use_array = []
    separator = "・"
    uses = {
      touring: self.touring,
      race: self.race,
      shopping: self.shopping,
      commute: self.commute,
      work: self.work,
      etcetera: self.etcetera,
    }

    uses.each do |key, value|
      if value.present?
        use_array << Review.human_attribute_name(key)
      end
    end

    use_array.join(separator).to_s
  end

  def get_execut_name(status)
    STATUS[status]
  end

  def get_status_name
    STATUS_NAME[self.status]
  end
end
