module AuthStore
  module V1
    module Helpers

    module PostHelpers
      def like_a_post(user_id, post_id)
        if user_id
          liked_post = Like.find_by(post_id: post_id, liked_by_user_id: user_id)
          if liked_post
            nil
          else
            Like.create(post_id: post_id, liked_by_user_id: user_id)
            liked_post = Like.find_by(post_id: post_id, liked_by_user_id: user_id)
          end
        else
          {eror: "Invalid or expired token"}
        end
      end
      #
      def get_all_likes(user_id, post_id)
        if user_id
          likes = Like.find_by(post_id: post_id)
        else
          {eror: "Invalid or expired token"}
        end
      end

      def post_comment(user_id, params)
        if user_id
          comment = Comment.new(post_id: params[:post_id], commentator_id: user_id, content: params[:comment])
          if comment.save
            comment
          else
            nil
          end
        else
          {error: "Invalid or expired token"}
        end
      end

      def get_all_post_comments(params, user_id)
        if user_id
          comments = Comment.where(post_id: params[:post_id])
        else
          {error: "Invalid or expired token"}
        end
      end

      def update_post(user_id, params)
        post = Post.find_by(id: params[:post_id], creator_id: user_id)

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
        tagged_ids = params[:tags].split(',')
        post = Post.create(caption: params[:caption], location: params[:location], creator_id: user_id, is_deleted: false)
        uploaded_pictures = params[:images]
        upload_directory = 'uploads/pictures'
        FileUtils.mkdir_p(upload_directory) unless File.directory?(upload_directory)

        uploaded_pictures.each do |uploaded_picture|
          filename = SecureRandom.uuid + File.extname(uploaded_picture[:filename])
          file_path = File.join(upload_directory, filename)

          File.open(file_path, 'wb') { |file| file.write(uploaded_picture[:tempfile].read) }

          Content.create(post_id: post.id, content_type: 'image', content_url: file_path)
        end
        tagged_ids.each do |tagged_id|
          Tag.create(tagged_user_id: tagged_id, post_id: post.id)
        end
        contents = Content.where(post_id: post.id)
        tags = Tag.where(post_id: post.id)
        {post: post, tags: tags, contents: contents}
      end

      def delete_post(user_id, post_id)
        Post.where(id: post_id, creator_id: user_id).update({
                                                                         is_deleted: true
                                                                  })
      end

      def get_user_posts(user_id)
        posts = Post.where(creator_id: user_id, is_deleted: false)
      end

      def get_feed_posts(user_id)
        posts = Post.where.not(creator_id: user_id).where(is_deleted: false)
      end

      def validate_jwt_token(jwt_token)
        return nil unless jwt_token

        begin
          decoded_token = JWT.decode(jwt_token, 'sayantan_secret_key', true, algorithm: 'HS256')
          puts(decoded_token)
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