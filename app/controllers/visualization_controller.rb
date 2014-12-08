class VisualizationController < ApplicationController
  def time
    @time_taken_parallel = TimeTaken.where(:method => "cosine_inverted_index_parallel")
    @time_taken = TimeTaken.where(:method => "cosine")
  end

  def jaccardVisualization
        
  end

  def loadJaccardVisualSequence
      @time_taken_parallel = TimeTaken.where(:method => "jaccard")
      render :json => @time_taken_parallel.to_json
  end

  
  def loadTimeSequence
    @time_taken_parallel = TimeTaken.where(:method => "cosine")
    render :json => @time_taken_parallel.to_json
  end

  def loadTimeParallel
    @time_taken = TimeTaken.where(:method => "cosine_inverted_index_parallel")
    render :json => @time_taken.to_json
  end

  def graph_sequence

  end

  def graph_parallel
    
  end
end
