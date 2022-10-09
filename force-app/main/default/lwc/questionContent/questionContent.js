import { LightningElement, api, track } from 'lwc';

export default class QuestionContent extends LightningElement {
    @api thisQuestions
    @track submitAnswers = [];
    keysArray = [];

    handleClick(event){
        const optionId = event.target.dataset.id;
        const questionId = event.target.dataset.qid;

        if(!this.keysArray.includes(questionId)){
            this.keysArray.push(questionId)
            this.submitAnswers.push({
                [questionId] : optionId
            });
        }else{
            this.submitAnswers[this.submitAnswers.findIndex(index => {
                return index.questionId != optionId
            })][`${questionId}`] = optionId;

        }
        console.log(optionId);
        console.log(questionId);
        console.log(this.submitAnswers);
        console.log(this.submitAnswers.length);
        console.log(this.thisQuestions.length);
    }
}