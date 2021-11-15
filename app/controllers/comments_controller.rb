class CommentsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :delete, :reply_new]

    def new
        comment = Comment.new
        comment.comment = params[:comment]
        comment.user_id = current_user.id
        product = Product.friendly.find(params[:slug])
        comment.product_id = product.id
        comment.save

        if comment.invalid?
            flash[:alert_comment] = comment.errors.full_messages
        else
            flash[:success_comment] = "You've created a new comment"
        end

        redirect_to products_show_path(category: "all", slug: params[:slug])
    end

    def delete
        comment = Comment.find(params[:id].to_i)
        if comment.user_id == current_user.id
            comment.destroy
        end

        if comment.destroyed?
            flash[:success_comment] = "You've deleted a comment"
        else
            flash[:alert_comment] = ["You've failed to delete a comment"]
        end

        redirect_to products_show_path(category: "all", slug: params[:slug])
    end

    def reply_new
        product = Product.friendly.find(params[:slug])
        comment = Comment.new
        comment.comment = params[:comment]
        comment.user_id = current_user.id
        comment.product_id = product.id
        comment.parent_comment = Comment.find(params[:id].to_i)
        comment.save

        if comment.invalid?
            flash["alert_reply_#{params[:id]}".to_sym] = comment.errors.full_messages
        else
            flash["success_reply_#{params[:id]}".to_sym] = "You've replied to this comment"
        end

        redirect_to products_show_path(category: "all", slug: params[:slug])
    end

    def reply_delete
        comment = Comment.find(params[:id].to_i)
        if comment.user_id == current_user.id
            comment.destroy
        end

        if comment.destroyed?
            flash["success_reply_#{comment.parent_comment.id}".to_sym] = "You've deleted a reply to this comment"
        else
            flash["alert_reply_#{comment.parent_comment.id}".to_sym] = ["You've failed to delete a reply to this comment"]
        end

        redirect_to products_show_path(category: "all", slug: params[:slug])
    end
end
