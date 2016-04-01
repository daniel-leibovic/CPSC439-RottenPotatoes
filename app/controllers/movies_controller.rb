class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false
    
    if params[:sort_by]
      @sorted_column = params[:sort_by]
      session[:sort_by] = @sorted_column
    elsif session[:sort_by]
      @sorted_column = session[:sort_by]
    else
      @sorted_column = nil
    end

    if params[:ratings]
      @set_ratings = params[:ratings]
      session[:ratings] = @set_ratings
    elsif session[:ratings]
      @set_ratings = session[:ratings]
      redirect = true
    else
      @set_ratings = nil
    end

    if redirect
      flash.keep
      redirect_to movies_path :sort_by=>@sorted_column, :ratings=>@set_ratings
    end

    if @set_ratings and @sorted_column
      @movies = Movie.where(:rating => @set_ratings.keys).find(:all, :order => (@sorted_column))
    elsif @set_ratings
      @movies = Movie.where(:rating => @set_ratings.keys)
    elsif @sorted_column
      @movies = Movie.find(:all, :order => (@sorted_column))
    else
      @movies = Movie.all
    end
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
