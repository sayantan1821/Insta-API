module AuthStore
  module V1
    module Helpers

      class PostHelpers
        def like_a_post(user_id, post_id)
          post = Post.find_by(id: post_id)
          if post == nil
            return { error: "post not found" }
          end
          if user_id
            liked_post = Like.find_by(post_id: post_id, liked_by_user_id: user_id)
            if liked_post
              { error: "User have already liked the post." }
            else
              Like.create(post_id: post_id, liked_by_user_id: user_id)
              { liked_post: Like.find_by(post_id: post_id, liked_by_user_id: user_id), message: "Like saved successfully." }
            end
          else
            { error: "Invalid or expired token" }
          end
        end

        #
        def get_all_likes(user_id, post_id)
          post = Post.find_by(id: post_id)
          if post == nil
            return { error: "post not found" }
          end
          # if user_id
          { likes: Like.where(post_id: post_id), message: "Likes retrieved successfully" }
          # end
        end

        def post_comment(user_id, params)
          post = Post.find_by(id: params[:post_id])
          if post == nil
            return { error: "post not found" }
          end
          comment = Comment.new(post_id: params[:post_id], commentator_id: user_id, content: params[:comment])
          if comment.save
            { comment: comment, message: "Comment saved successfully." }
          else
            { error: "Failed to save comment." }
          end
        end

        def get_all_post_comments(params, user_id)
          post = Post.find_by(id: params[:post_id])
          if post == nil
            return { error: "post not found" }
          end
          if user_id
            { comments: Comment.where(post_id: params[:post_id]), message: "Comments retrieved successfully" }
          else
            { error: "Invalid or expired token" }
          end
        end

        def update_post(user_id, params)
          post = Post.find_by(id: params[:post_id], creator_id: user_id)
          if post == nil
            return nil
          end
          post.caption = params[:caption] if params[:caption].present?
          # post.tags = params[:tags] if params[:tags].present?
          post.location = params[:location] if params[:location].present?
          if post.save
            post
          else
            nil
          end
        end

        def create_post(user_id, params)
          post = Post.create(caption: params[:caption], location: params[:location], creator_id: user_id, is_deleted: false)
          # p params[:tags]

          if params[:tags].present?
            tagged_ids = params[:tags].split(',')
            # p tagged_ids
            tagged_ids.each do |tagged_id|
              # unless User.exists?(id: user_id)
              #   return {"error": "Invalid tagged user id"}
              # end
              Tag.create(tagged_user_id: tagged_id, post_id: post.id)
            end
          end
          uploaded_pictures = params[:images]
          if uploaded_pictures.present?
            upload_directory = 'uploads/pictures'
            FileUtils.mkdir_p(upload_directory) unless File.directory?(upload_directory)

            uploaded_pictures.each do |uploaded_picture|
              filename = SecureRandom.uuid + File.extname(uploaded_picture[:filename])
              file_path = File.join(upload_directory, filename)

              File.open(file_path, 'wb') { |file| file.write(uploaded_picture[:tempfile].read) }

              Content.create(post_id: post.id, content_type: 'image', content_url: file_path)
            end
          end

          contents = Content.where(post_id: post.id)
          tags = Tag.where(post_id: post.id)
          { post: post, tags: tags, contents: contents }
        end

        def delete_post(user_id, post_id)
          post = Post.find_by(id: post_id, creator_id: user_id)
          if post
            post.update({
                          is_deleted: true
                        })
          else
            nil
          end
        end
        def get_user_posts(user_id)
          posts = Post.where(creator_id: user_id, is_deleted: false)

          # resp_data = []
          # posts.each do |post|
          #   data = nil
          #   data[:contents] = Content.where(post_id: post.id)
          #   data[:tags] = Tag.where(post_id: post.id)
          #   data[:likes] = Like.where(post_id: post.id)
          #   data[:comments] = Comment.where(post_id: post.id)
          #   resp_data << data
          # end
          # resp_data
        end

        def get_feed_posts(user_id)
          posts = Post.where.not(creator_id: user_id).where(is_deleted: false)
        end

        def validate_jwt_token(jwt_token)
          return nil unless jwt_token

          begin
            decoded_token = JWT.decode(jwt_token, 'sayantan_secret_key', true, algorithm: 'HS256')
            # puts(decoded_token)
            user_id = decoded_token[0]['user_id']
          rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
            return nil
          end
          user_id
        end
      end
    end
  end

end