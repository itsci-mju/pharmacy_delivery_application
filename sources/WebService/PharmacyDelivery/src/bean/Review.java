package bean;
import java.util.Calendar;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="Review")
public class Review {
	@Id
	private String reviewId;
	
	@Column(name="score")
	private Integer score;
	
	@Column(name="comment")
	private String comment;
	
	@Column(name="reviewDate")
	private Calendar reviewDate;

	public Review() {
	}

	public Review(String reviewId, Integer score, String comment, Calendar reviewDate) {
		super();
		this.reviewId = reviewId;
		this.score = score;
		this.comment = comment;
		this.reviewDate = reviewDate;
	}

	public String getReviewId() {
		return reviewId;
	}

	public void setReviewId(String reviewId) {
		this.reviewId = reviewId;
	}

	public Integer getScore() {
		return score;
	}

	public void setScore(Integer score) {
		this.score = score;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public Calendar getReviewDate() {
		return reviewDate;
	}

	public void setReviewDate(Calendar reviewDate) {
		this.reviewDate = reviewDate;
	}

	
	
}
