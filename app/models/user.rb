class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #フォローする側のUserから見て、フォローされる側のUserを(中間テーブルを介して)集める。なので親はfollowing_id(フォローする側)
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  # 中間テーブルを介して「follower」モデルのUser(フォローされた側)を集めることを「followings」と定義
  has_many :followings, through: :active_relationships, source: :follower
  # ========================================================================================

  # ====================自分がフォローされるユーザーとの関連 ===================================
  #フォローされる側のUserから見て、フォローしてくる側のUserを(中間テーブルを介して)集める。なので親はfollower_id(フォローされる側)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  # 中間テーブルを介して「following」モデルのUser(フォローする側)を集めることを「followers」と定義
  has_many :followers, through: :passive_relationships, source: :following

  def followed_by?(user)
    # 今自分(引数のuser)がフォローしようとしているユーザー(レシーバー)がフォローされているユーザー(つまりpassive)の中から、引数に渡されたユーザー(自分)がいるかどうかを調べる
    passive_relationships.find_by(following_id: user.id).present?
  end

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  attachment :profile_image, destroy: false

  def User.search(search, user_or_post, how_search)
        if user_or_post == "1"
            if how_search == "4"
                    User.where(['name LIKE ?', "%#{search}%"])
            elsif how_search == "3"
                    User.where(['name LIKE ?', "%#{search}"])
            elsif how_search == "2"
                    User.where(['name LIKE ?', "#{search}%"])
            elsif how_search == "1"
                    User.where(['name LIKE ?', "#{search}"])
            else
                    User.all
            end
         end
    end

    include JpPrefecture
      jp_prefecture :prefecture_code

      def prefecture_name
        JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
      end

      def prefecture_name=(prefecture_name)
        self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
      end
  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}
end