import { LightningElement, api, wire, track } from 'lwc';
import getTrailWrapper from '@salesforce/apex/UnitService.getUnitWrapper';
import getUnitWrapper from '@salesforce/apex/UnitService.getUnitWrapper';
export default class UnitContent extends LightningElement {
    @api recordId
    error = undefined;
    wrapper;
    thisQuestions;
    thisUnit;
    

    @wire(getUnitWrapper, {unitId: '$recordId'})
    unit({ data, error }) {
        if(data) {
            this.wrapper = data;
            this.thisUnit = data.thisUnit;
            this.thisQuestions = data.thisQuestions;
        }else if(error) {
            this.error = error;
        }
    }

    // get correctUnit(){
    //     return this.thisUnit.contains()
    // }

    // connectedCallback(){
    //     getUnitWrapper({unitId: '$recordId'}).then((data)=>{
    //         this.thisUnit = data.thisUnit;
    //         this.thisQuestions = data.thisQuestions;
    //     }).catch((error) =>{
    //         this.error = error;
    //     })
    // }
    // @wire(getUnitWrapper, {unitId: '$recordId'})
    // unit({ data, error }) {
    //     if(data) {
    //         this.wrapper = data;
    //         this.thisUnit = data.thisUnit;
    //         this.thisQuestions = data.thisQuestions;
    //     }else if(error) {
    //         this.error = error;
    //     }
    // }
    
    // get unit(){
    //     return this.thisUnit = this.wrapper.data.thisUnit;
    // }

    handleClick(){
        console.log('WRAPPER');
        console.log(this.wrapper)
        console.log('UNIT');
        console.log(this.thisUnit);
        console.log('QUESTIONS');
        console.log(this.thisQuestions);
    }
}