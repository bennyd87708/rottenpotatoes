class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      sort = ''
      @title_header = ''
      @release_date_header = ''
      @all_ratings = Movie.all_ratings
      @ratings_to_show = {}
      
      for rating in @all_ratings
        @ratings_to_show[rating] = 1
      end

      if session[:sort]
        sort = session[:sort]
      end
      if params[:sort]
        sort = params[:sort]
      end
      if sort == 'title'
        @title_header = 'hilite bg-warning'
      end
      if sort == 'release_date'
        @release_date_header = 'hilite bg-warning'
      end
      if session[:ratings]
        @ratings_to_show = session[:ratings]
      end
      if params[:ratings]
        @ratings_to_show = params[:ratings]
      end

      if params[:sort] != session[:sort]
        session[:sort] = sort
        redirect_to :sort => sort, :ratings => @ratings_to_show and return
      end
      if params[:ratings] != session[:ratings]
        session[:ratings] = @ratings_to_show
        redirect_to :sort => sort, :ratings => @ratings_to_show and return
      end

      @movies = Movie.with_ratings(@ratings_to_show.keys)
      if sort == 'title'
        @movies = @movies.order({:title => :asc})
      end
      if sort == 'release_date'
        @movies = @movies.order({:release_date => :asc})
      end
    end
  
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end