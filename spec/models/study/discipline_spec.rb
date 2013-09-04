require 'spec_helper'

describe Study::Discipline do
  context 'обладает связями с другими моделями:' do
    it 'связан с группой' do
      should belong_to(:group)
    end
    it 'связан с ведущим преподавателем' do
      should belong_to(:lead_teacher)
    end
    it { should have_many(:discipline_teachers) }
    it { should have_many(:assistant_teachers).through(:discipline_teachers) }
    it { should have_many(:lectures) }
    it { should have_many(:seminars) }
    it { should have_many(:checkpoints) }
    it { should have_many(:classes) }
    it { should have_many(:exams) }
    it { should have_many(:final_exams) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:year) }
    it { should validate_numericality_of(:year)
                .is_greater_than(2012).is_less_than(2020) }

    it { should validate_presence_of(:semester) }
    it { should ensure_inclusion_of(:semester).in_array([1,2]) }

    it { should validate_presence_of(:group) }
    it { should validate_presence_of(:lead_teacher) }
    it { should validate_presence_of(:final_exams) }
  end
end