class Study::ExamMarksController < ApplicationController

  def ajax_update
    @mark = Study::ExamMark.find(params[:id])
    params[:rating_value] = (params[:rating_value] == '' ? 0 : params[:rating_value])
    @mark.update(value: params[:rating_value])
    @final = Study::ExamMark.find(params[:final_mark])
    @final.update(value: params[:final_value])
    render({ json: {id: @mark.id, result: @mark.value,
                      color:  @final.long_result[:color]}
             })
  end

end