class Status
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.all
    statuses = []
    statuses << Status.new(1,   'неизвестный')
    statuses << Status.new(100, 'абитуриент')
    statuses << Status.new(101, 'студент')
    statuses << Status.new(102, 'отчисленный')
    statuses << Status.new(103, 'академический отпуск')
    statuses << Status.new(104, 'выпускник')
    statuses << Status.new(105, 'аспирант')
    statuses << Status.new(106, 'окончивший')
    statuses << Status.new(108, 'переведенный должник')

    statuses
  end
end