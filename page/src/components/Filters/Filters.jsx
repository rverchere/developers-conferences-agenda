import React, { useState, useCallback, useContext, useEffect, useMemo } from 'react';
import { useSearchParams } from "react-router-dom";

import { Filter, FilterX } from 'lucide-react';

import { useCountries, useRegions, useRegionsMap } from 'app.hooks';

import 'styles/Filters.css';
import { FilterContext } from 'contexts/FilterContext';

const Filters = ({ view }) => {
  const context = useContext(FilterContext);
  const [searchParams, setSearchParams] = useSearchParams(context.searchParams);
  const [open, setOpen] = useState(context.open);

  useEffect(() => {
    context.searchParams = searchParams;
    context.open = open;
  }, [searchParams, open]);

  const onChange = useCallback((key, value) => {
    if (key === 'region') {
      setSearchParams({ ...Object.fromEntries(searchParams), region: value, country: '' })
    } else {
      setSearchParams({ ...Object.fromEntries(searchParams), [key]: value })
    }
  }, [searchParams, setSearchParams]);

  const countries = useCountries()
  const regions = useRegions()
  const regionsMap = useRegionsMap()

  const search = Object.fromEntries(searchParams)

  const countriesList = useMemo(() => {
    let result = countries
    if (search.region) {
      result = regionsMap[search.region]
      result.sort()
    }
    return result
  }, [search.region, regionsMap, countries])

  return (
    <div className={"filters " + (open ? 'open' : 'closed')}>
      <div
        className='filters-header'
        title={open ? 'Close filters' : 'Open filters'}
        onClick={() => {
          if (open) {
            // setSearchParams({});
            setOpen(false);
            return;
          }
          setOpen(true);
        }}
      >
        <div className='filters-icon'>{open ? <FilterX size={'32px'} /> : <Filter size={'32px'} />}</div>
        <span className='filters-title'>Filters</span>
      </div>

      <div className='filtersItem'>
        <label htmlFor='filter-query'>Query:</label>
        <input id='filter-query' type='text' value={search.query} onChange={(e) => onChange('query', e.target.value)} placeholder="Search..." />
      </div>

      {view === "cfp" ? 
      <div className='filtersItem'>
        <label htmlFor='filter-until'>Until:</label>
        <input id="filter-until" type="date" value={search.untilDate} onChange={(e) => onChange('untilDate', e.target.value)} />
      </div> : ''}
      
      <div className='filtersList'>

        {view != "cfp" ? 
        <div className='filtersItem'>
          <input checked={search.callForPapers == 'true'} type='checkbox' id='filter-call-for-papers' onChange={(e) => onChange('callForPapers', e.target.checked)} />
          <label htmlFor='filter-call-for-papers'>Call For Papers Open</label>
        </div> : ''}

        {view != "cfp" ?
        <div className='filtersItem'>
          <input checked={search.closedCaptions == 'true'} type='checkbox' id='filter-closed-captions' onChange={(e) => onChange('closedCaptions', e.target.checked)} />
          <label htmlFor='filter-closed-captions'>Closed Captions</label>
        </div> : ''}

        {view != "cfp" ?
        <div className='filtersItem'>
          <input checked={search.scholarship == 'true'} type='checkbox' id='filter-scholarship' onChange={(e) => onChange('scholarship', e.target.checked)} />
          <label htmlFor='filter-scholarship'>Scholarship</label>
        </div> : ''}

        <div className='filtersItem'>
          <input checked={search.online == 'true'} type='checkbox' id='filter-online' onChange={(e) => onChange('online', e.target.checked)} />
          <label htmlFor='filter-online'>Online</label>
        </div>
      </div>

      <div className='filtersItem'>
        <label htmlFor='filter-region'>Region:</label>
        <select value={search.region} id='filter-region' onChange={(e) => onChange('region', e.target.value)}>
          <option value=''>All</option>
          {regions.map((c) => (<option value={c} key={c}>{c}</option>))}
        </select>
      </div>

      {countriesList &&
        <div className='filtersItem'>
          <label htmlFor='filter-country'>Country:</label>
          <select value={search.country} id='filter-country' onChange={(e) => onChange('country', e.target.value)}>
            <option value=''>All</option>
            {countriesList.map((c) => (<option value={c} key={c}>{c}</option>))}
          </select>
        </div>}

    </div>
  );
};

export default Filters;
